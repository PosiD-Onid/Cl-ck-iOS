//
//  Lesson.swift
//  Cl!ck
//
//  Created by 이다경 on 9/11/24.
//

import Foundation

struct Lesson: Identifiable, Decodable {
    let id: Int
    let l_title: String
    let l_content: String
    let l_grade: Int
    let l_class: Int
    let l_semester: Int
    let l_place: String
    let l_year: Int
    let t_id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "l_id"
        case l_title
        case l_content
        case l_grade
        case l_class
        case l_semester
        case l_place
        case l_year
        case t_id
    }
}
