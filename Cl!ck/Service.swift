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
}
