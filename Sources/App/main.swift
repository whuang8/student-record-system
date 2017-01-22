import Vapor
import VaporPostgreSQL
import HTTP


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += TodoItem.self

drop.get { req in
    let todoItems = try TodoItem.all()
    return try drop.view.make("welcome", [
    	"todoItems": todoItems.makeNode()
    ])
}

drop.get("db_version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT Version()")
        return JSON(version)
    }
    return "Error connecting to db"
}

drop.get("add") { request in
    return try drop.view.make("add")
}

drop.post("create") { request in
    if let action = request.data["action"], let author = request.data["author"] {
        var todoItem = TodoItem(action: action.string!, author: author.string!)
        try todoItem.save()
        var response = Response(redirect: "/")
        return response
    }
    return "error adding"
}

drop.resource("posts", PostController())

drop.run()
