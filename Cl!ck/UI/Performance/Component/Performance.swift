//
//  Performance.swift
//  Cl!ck
//
//  Created by 이다경 on 9/13/24.
//

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
}
