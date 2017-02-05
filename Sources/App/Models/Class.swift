import Vapor

final class Class: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var name: String
    
    init(name: String, enrollment: Int) {
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }
    static func prepare(_ database: Database) throws {
        try database.create("classes", closure: { (classes) in
            classes.id()
            classes.string("name", length: nil, optional: false, unique: true, default: nil)
        })
    }
    static func revert(_ database: Database) throws {
        try database.delete("classes")
    }
}
