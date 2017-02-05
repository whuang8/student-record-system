import Vapor
import VaporPostgreSQL
import HTTP


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Student.self
drop.preparations += Class.self

drop.get { req in
    return try drop.view.make("welcome")
}

drop.get("db_version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT Version()")
        return JSON(version)
    }
    return "Error connecting to db"
}

let studentsController = StudentsController()
drop.resource("api/students", studentsController)


drop.run()
