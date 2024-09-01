//
//  NetworkResult.swift
//  Cl!ck
//
//  Created by 이다경 on 9/1/24.
//

/*
 서버 통신의 결과를 핸들링 하기 위한 열거형 선언
 */
enum NetworkResult<T> {
    case success(T) // 서버 통신 성공
    case requestErr(T) //요청 에러가 발생
    case pathErt // 경로 에러
    case serverErr //서버의 내부 에러
    case networkFail //네트워크 연결실패
}
