import Foundation
import Alamofire

class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    func s_signup(s_id: String, s_name: String, s_pass: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.s_signupURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: Parameters = [
            "s_id": s_id,
            "s_name": s_name,
            "s_pass": s_pass
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                
                if (200...299).contains(statusCode) {
                    completion(.success("회원가입 성공"))
                } else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        if responseString.contains("비밀번호는 최소 8자 이상이어야 합니다.") {
                            completion(.requestErr("비밀번호는 최소 8자 이상이어야 합니다."))
                        } else if responseString.contains("이미 존재하는 아이디입니다.") {
                            completion(.requestErr("이미 존재하는 아이디입니다."))
                        } else {
                            completion(.requestErr(responseString))
                        }
                    } else {
                        completion(.pathErr)
                    }
                }
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    
    func t_signup(t_id: String, t_name: String, t_pass: String, t_subject: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.t_signupURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: Parameters = [
            "t_id": t_id,
            "t_name": t_name,
            "t_pass": t_pass,
            "t_subject": t_subject
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                
                if (200...299).contains(statusCode) {
                    completion(.success("회원가입 성공"))
                } else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        if responseString.contains("비밀번호는 최소 8자 이상이어야 합니다.") {
                            completion(.requestErr("비밀번호는 최소 8자 이상이어야 합니다."))
                        } else if responseString.contains("이미 존재하는 아이디입니다.") {
                            completion(.requestErr("이미 존재하는 아이디입니다."))
                        } else {
                            completion(.requestErr(responseString))
                        }
                    } else {
                        completion(.pathErr)
                    }
                }
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func signin(username: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.signinURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: Parameters = [
            "id": username,
            "password": password
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                
                do {
                    // JSON 데이터를 파싱
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if (200...299).contains(statusCode) {
                            // 성공적인 로그인
                            if let userType = jsonObject["userType"] as? String,
                               let userId = jsonObject["userId"] as? String {
                                completion(.success((userType, userId)))
                            } else {
                                completion(.pathErr)
                            }
                        } else {
                            // 로그인 실패 처리
                            if let errorMessage = jsonObject["message"] as? String {
                                completion(.requestErr(errorMessage)) // 서버에서 받은 에러 메시지 전송
                            } else {
                                completion(.requestErr("로그인에 실패했습니다.")) // 기본 에러 메시지
                            }
                        }
                    } else {
                        completion(.pathErr)
                    }
                } catch {
                    completion(.pathErr)
                }
                
            case .failure:
                completion(.networkFail)
            }
        }
    }

    
    func signout(completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.signoutURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .post, // 로그아웃이 POST 요청이라 가정
                                     headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                
                if (200...299).contains(statusCode) {
                    completion(.success("로그아웃 성공"))
                } else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        completion(.requestErr(responseString))
                    } else {
                        completion(.pathErr)
                    }
                }
            case .failure:
                completion(.networkFail)
            }
        }
    }
}
