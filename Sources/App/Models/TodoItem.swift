import Vapor

final class TodoItem: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var action: String
    var author: String
    
    init(action: String, author: String) {
        self.id = nil
        self.action = action
        self.author = author
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.action = try node.extract("action")
        self.author = try node.extract("author")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "action": action,
            "author": author
        ])
    }
    
    
    static func prepare(_ database: Database) throws {
        try database.create("todoitems", closure: { (users) in
            users.id()
            users.string("action")
            users.string("author")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("todoitems")
    }
    
}
