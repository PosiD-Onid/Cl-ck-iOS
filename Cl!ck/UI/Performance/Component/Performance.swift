//
//  Performance.swift
//  Cl!ck
//
//  Created by 이다경 on 9/13/24.
//

import Foundation

struct Performance: Codable, Identifiable {
    var id: Int
    var title: String
    var place: String?
    var content: String
    var startDate: String
    var endDate: String
    var l_id: Int
    var createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "p_id"
        case title
        case place
        case content
        case startDate
        case endDate
        case l_id
        case createdAt
        case updatedAt
    }
}

