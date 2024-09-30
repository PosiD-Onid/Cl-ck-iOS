//
//  Evaluation.swift
//  Cl!ck
//
//  Created by 이다경 on 9/23/24.
//

import Foundation

import Foundation

struct Evaluation: Codable, Identifiable {
    var id: Int
    var e_score: Int
    var e_check: Bool
    var s_classof: Int
    var s_name: String
    var p_id: String
    var p_title: String
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "l_id"
        case e_score
        case e_check
        case s_classof
        case s_name
        case p_id
        case p_title
    }
}
