//
//  Lesson.swift
//  Cl!ck
//
//  Created by 이다경 on 9/11/24.
//

import Foundation

struct Lesson: Identifiable, Decodable {
    let id: UUID
    let l_title: String
    let l_content: String
    let l_year: Int
    let l_semester: Int
    let l_grade: Int
    let l_class: Int
    let l_place: String
    let t_id: String // 선생님 ID
}
