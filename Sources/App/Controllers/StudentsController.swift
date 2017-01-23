import Vapor
import HTTP

final class StudentsController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        let json = try JSON(node: Student.all().makeNode())
        return json
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var student = try request.student()
        try student.save()
        return student
    }
    
    func show(request: Request, student: Student) throws -> ResponseRepresentable {
        return student
    }
    
    func update(request: Request, student: Student) throws -> ResponseRepresentable {
        let new = try request.student()
        var student = student
        student.firstName = new.firstName
        student.lastName = new.lastName
        student.email = new.email
        student.classification = new.classification
        try student.save()
        return student
    }
    
    func delete(request: Request, student: Student) throws -> ResponseRepresentable {
        try student.delete()
        return JSON([:])
    }
    
    
    public func makeResource() -> Resource<Student> {
        return Resource(
            index: index,
            store: store,
            show: show,
            modify: update,
            destroy: delete
        )
    }
}

extension Request {
    func student() throws -> Student {
        guard let json = self.json else {
            throw Abort.badRequest
        }
        return try Student(node: json)
    }
}
