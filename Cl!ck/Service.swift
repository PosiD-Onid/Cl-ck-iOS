import Alamofire
import Foundation

class Service {
    static let shared = Service()
    private init() {}
    
    func createLesson(title: String, content: String, grade: String, class: String, semester: String, place: String, year: String, teacherId: String, completion: @escaping (Result<Lesson, Error>) -> Void) {
        let url = APIConstants.createLessonURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: [String: Any] = [
            "l_title": title,
            "l_content": content,
            "l_year": year,
            "l_semester": semester,
            "l_grade": grade,
            "l_class": `class`,
            "l_place": place,
            "t_id": teacherId
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: header)
        .responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Response JSON: \(json)")
                
                if let jsonObject = json as? [String: Any] {
                    do {
                        if let lessonData = jsonObject["lesson"] as? [String: Any] {
                            let jsonData = try JSONSerialization.data(withJSONObject: lessonData, options: [])
                            let lesson = try JSONDecoder().decode(Lesson.self, from: jsonData)
                            completion(.success(lesson))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다: Lesson 데이터가 없음"])
                            completion(.failure(error))
                        }
                    } catch {
                        print("JSON 디코딩 실패: \(error)")
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다"])
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("수업 생성 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func readLessons(teacherId: String, completion: @escaping (Result<[Lesson], Error>) -> Void) {
        let url = APIConstants.readLessonsURL(teacherId: teacherId)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .get, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Response JSON: \(json)")
                    
                    if let jsonArray = json as? [[String: Any]] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                            let lessons = try JSONDecoder().decode([Lesson].self, from: jsonData)
                            completion(.success(lessons))
                        } catch {
                            print("JSON 디코딩 실패: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다"])
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("수업 읽기 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func updateLesson(id: String, title: String, content: String, grade: String, class: String, semester: String, place: String, year: String, teacherId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConstants.updateLessonURL(teacherId: teacherId, id: id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: [String: Any] = [
            "l_id": id,
            "l_title": title,
            "l_content": content,
            "l_year": year,
            "l_semester": semester,
            "l_grade": grade,
            "l_class": `class`,
            "l_place": place,
            "t_id": teacherId
        ]
        
        AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let jsonObject = json as? [String: Any], let message = jsonObject["message"] as? String {
                        completion(.success(message))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("수업 업데이트 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func createPerformance(title: String, place: String?, content: String, startDate: String, endDate: String, lessonId: String, completion: @escaping (Result<Performance, Error>) -> Void) {
        let url = APIConstants.createPerformanceURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: [String: Any] = [
            "p_title": title,
            "p_place": place ?? NSNull(),
            "p_content": content,
            "p_startdate": startDate,
            "p_enddate": endDate,
            "l_id": lessonId
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: ["params": body],
                   encoding: JSONEncoding.default,
                   headers: header)
        .responseJSON { response in
            switch response.result {
            case .success(let json):
                print("Response JSON: \(json)")
                
                if let jsonObject = json as? [String: Any] {
                    do {
                        if let performanceData = jsonObject["performance"] as? [String: Any] {
                            let jsonData = try JSONSerialization.data(withJSONObject: performanceData, options: [])
                            let performance = try JSONDecoder().decode(Performance.self, from: jsonData)
                            completion(.success(performance))
                        } else {
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다: Performance 데이터가 없음"])
                            completion(.failure(error))
                        }
                    } catch {
                        print("JSON 디코딩 실패: \(error)")
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다"])
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("수행평가 생성 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // 수행평가 전체 조회
    func readPerformances(lessonId: String, completion: @escaping (Result<[Performance], Error>) -> Void) {
        let url = APIConstants.readPerformanceURL(lessonId: lessonId)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .get, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Response JSON: \(json)")
                    
                    if let jsonArray = json as? [[String: Any]] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                            let performances = try JSONDecoder().decode([Performance].self, from: jsonData)
                            completion(.success(performances))
                        } catch {
                            print("JSON 디코딩 실패: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다"])
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("수행평가 조회 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // 수행평가 단건 조회
    func readPerformance(lessonId: String, id: String, completion: @escaping (Result<Performance, Error>) -> Void) {
        let url = APIConstants.readPerformancesURL(lessonId: lessonId, id: id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .get, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Response JSON: \(json)")
                    
                    if let jsonObject = json as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                            let performance = try JSONDecoder().decode(Performance.self, from: jsonData)
                            completion(.success(performance))
                        } catch {
                            print("JSON 디코딩 실패: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다"])
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("수행평가 단건 조회 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // 수행평가 업데이트
    func updatePerformance(id: String, title: String, place: String?, content: String, startDate: String, endDate: String, lessonId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConstants.updatePerformanceURL(lessonId: lessonId, id: id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body: [String: Any] = [
            "p_id": id, // 추가된 부분: p_id를 body에 포함
            "p_title": title,
            "p_place": place ?? NSNull(),
            "p_content": content,
            "p_startdate": startDate,
            "p_enddate": endDate,
            "l_id": lessonId
        ]
        
        AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let jsonObject = json as? [String: Any], let message = jsonObject["message"] as? String {
                        completion(.success(message))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 형식이 잘못되었습니다."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("수행평가 업데이트 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
