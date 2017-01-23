import Vapor

final class Student: Model {
    
    var id: Node?
    var exists: Bool = false
    
    var firstName: String
    var lastName: String
    var email: String
    var classification: String
    
    init(firstName: String, lastName: String, email: String, classification: String) {
        self.id = nil
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.classification = classification
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.firstName = try node.extract("firstname")
        self.lastName = try node.extract("lastname")
        self.email = try node.extract("email")
        self.classification = try node.extract("classification")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "firstname": firstName,
            "lastname": lastName,
            "email": email,
            "classification": classification
        ])
    }
    
    
    static func prepare(_ database: Database) throws {
        try database.create("students", closure: { (users) in
            users.id()
            users.string("firstname")
            users.string("lastname")
            users.string("email")
            users.string("classification")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("students")
    }
    
}
