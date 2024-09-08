//
//  APIConstants.swift
//  Cl!ck
//
//  Created by 이다경 on 9/8/24.
//

import Foundation

struct APIConstants {
    static let baseURL = "http://localhost:7221/api"

    // 로그인
    static let signinURL = baseURL + "/auth/signin"

    // 학생 회원가입
    static let s_signupURL = baseURL + "/auth/s_signup"

    // 선생님 회원가입
    static let t_signupURL = baseURL + "/auth/t_signup"
    
    // 로그 아웃
    static let signoutURL = baseURL + "/auth/signout"
}
