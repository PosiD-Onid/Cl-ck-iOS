import Foundation

struct Performance: Codable, Identifiable {
    var id: Int
    var l_id: Int
    var p_title: String
    var p_content: String
    var p_place: String
    var p_startdate: String
    var p_enddate: String
    var createdAt: String
    var updatedAt: String
    var startDate: Date? // 옵셔널로 변경
    var endDate: Date? // 옵셔널로 변경

    enum CodingKeys: String, CodingKey {
        case id = "p_id"
        case l_id = "l_id"
        case p_title
        case p_content
        case p_place
        case p_startdate
        case p_enddate
        case createdAt
        case updatedAt
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.l_id = try container.decode(Int.self, forKey: .l_id)
        self.p_title = try container.decode(String.self, forKey: .p_title)
        self.p_content = try container.decode(String.self, forKey: .p_content)
        self.p_place = try container.decode(String.self, forKey: .p_place)
        self.p_startdate = try container.decode(String.self, forKey: .p_startdate)
        self.p_enddate = try container.decode(String.self, forKey: .p_enddate)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)

        // 날짜 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // JSON에서 사용하는 날짜 형식
        
        // 옵셔널로 변환하여 변환 실패 시 nil로 설정
        self.startDate = dateFormatter.date(from: p_startdate)
        self.endDate = dateFormatter.date(from: p_enddate)
    }
}
