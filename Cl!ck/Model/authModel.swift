//
//  S_signupModel.swift
//  Cl!ck
//
//  Created by 이다경 on 9/1/24.
//

import Foundation

struct S_signupResponse: Codable {
    let s_id: String
    let s_pass: String
    let s_name: String
}

struct T_signupResponse: Codable {
    let t_id: String
    let t_pass: String
    let t_name: String
    let t_subject: String
}

struct SigninResponse: Codable {
    let id: String
    let password: String
}
