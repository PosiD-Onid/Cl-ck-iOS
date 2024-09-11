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
                
                if (200...299).contains(statusCode) {
                    do {
                        // JSON 데이터를 파싱
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let userType = jsonObject["userType"] as? String {
                            if userType == "student" {
                                completion(.success("student"))
                            } else if userType == "teacher" {
                                completion(.success("teacher"))
                            } else {
                                completion(.pathErr)
                            }
                        } else {
                            completion(.pathErr)
                        }
                    } catch {
                        completion(.pathErr)
                    }
                } else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = jsonObject["message"] as? String {
                        // 서버에서 반환된 오류 메시지 처리
                        if message == "비밀번호가 일치하지 않습니다." {
                            completion(.requestErr("비밀번호가 일치하지 않습니다."))
                        } else if message == "가입되지 않은 회원입니다." {
                            completion(.requestErr("가입되지 않은 회원입니다."))
                        } else {
                            completion(.requestErr(message))
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
}
