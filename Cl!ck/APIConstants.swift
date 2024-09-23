//
//  APIConstants.swift
//  Cl!ck
//
//  Created by 이다경 on 9/8/24.
//

import Foundation

struct APIConstants {
    static let baseURL = "http://10.80.163.146:7221/api"

    // auth
    static let authURL = baseURL + "/auth"
    
    // 로그인
    static let signinURL = authURL + "/signin"

    // 학생 회원가입
    static let s_signupURL = authURL + "/s_signup"

    // 선생님 회원가입
    static let t_signupURL = authURL + "/t_signup"
    
    // 로그 아웃
    static let signoutURL = authURL + "/signout"
    
    // 수업
    static let LessonURL = baseURL + "/lesson"
    
    // 수업 생성
    static let createLessonURL = LessonURL + "/create"
    
    // 수업 조회 (전체 조회)
    static func readLessonsURL(teacherId: String) -> String {
            return LessonURL + "/teacher=\(teacherId)"
        }
    // 수업 조회 (한개 조회)
    static func readLessonURL(teacherId: String, id: String) -> String {
        return LessonURL + "/teacher=\(teacherId)/\(id)"
    }
    
    // 수업 업데이트
    static func updateLessonURL(teacherId: String, id: String) -> String {
        return LessonURL + "/teacher=\(teacherId)/update/\(id)"
    }
    
    // 수행평가
    static let PerformanceURL = baseURL + "/performance"
    
    // 수행평가 생성
    static let createPerformanceURL = PerformanceURL + "/create"
    
    // 수행평가 조회 (전체 조회)
    static func readPerformanceURL(lessonId: String) -> String {
        return PerformanceURL + "/lesson=\(lessonId)"
    }
    
    // 수행평가 조회 (한개 조회)
    static func readPerformancesURL(lessonId: String, id: String) -> String {
        return PerformanceURL + "/lesson=\(lessonId)/\(id)"
    }
    
    // 수행평가 업데이트
    static func updatePerformanceURL(lessonId: String, id: String) -> String {
        return PerformanceURL + "/lesson=\(lessonId)/update/\(id)"
    }
    
    // 점수
    static let EvaluationURL = baseURL + "/evaluation"
    
    // 점수 생성
    static let createEvaluationURL = EvaluationURL + "/create"
    
    // 점수 조회 (선생님)
    static func readEvaluationsTeacherURL(performance: String, s_classof: Int) -> String {
        return EvaluationURL + "/performance=\(performance)/s_classof=\(s_classof)"
    }
}
