//
//  Service.swift
//  Cl!ck
//
//  Created by 이다경 on 9/1/24.
//

import Foundation
import Alamofire

class UserService {
    
    static let shared = UserService()
    // UserService의 싱글톤 인스턴스를 생성합니다.
    
    private init() {}
    // private init()을 사용하여 외부에서 인스턴스를 생성할 수 없도록 합니다.
    
    func signup(s_id: String, s_name: String, s_pass: String, completion: @escaping(NetworkResult<Any>) -> Void) {
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
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                
                guard let value = response.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300:    return isValidData(data: data)
        case 400..<500: return .pathErr
        case 500..<600: return .serverErr
        default:        return .networkFail
        }
    }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignupResponse.self, from: data)
        else { return .pathErr }
        return .success(decodedData as Any)
    }
}
