import Foundation

struct Lesson: Codable, Identifiable {
    var id: Int
    var l_title: String
    var l_content: String
    var l_year: String
    var l_semester: String
    var l_grade: String
    var l_class: String
    var l_place: String
    var t_id: String
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "l_id"
        case l_title
        case l_content
        case l_year
        case l_semester
        case l_grade
        case l_class
        case l_place
        case t_id
        case createdAt
        case updatedAt
    }
}
