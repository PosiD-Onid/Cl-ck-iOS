import Alamofire
import Foundation

class Service {
    static let shared = Service()
    private init() {}
    
    func createLesson(title: String, content: String, grade: String, class: String, semester: String, place: String, year: String, teacherId: String, completion: @escaping (Result<Lesson, Error>) -> Void) {
        let url = APIConstants.createlessonURL
        let header: HTTPHeaders = ["Content-Type": "application/json"]

        let body: [String: Any] = [
            "l_title": title,
            "l_content": content,
            "l_grade": Int(grade) ?? 0,
            "l_class": Int(`class`) ?? 0,
            "l_semester": Int(semester) ?? 0,
            "l_place": place,
            "l_year": Int(year) ?? 0,
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
                    // 서버에서의 응답 JSON 데이터 로그 확인
                    print("Response JSON: \(json)")

                    // JSON에서 lesson 객체 추출
                    if let jsonObject = json as? [String: Any],
                       let lessonData = jsonObject["lesson"] as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: lessonData, options: [])
                            let lesson = try JSONDecoder().decode(Lesson.self, from: jsonData)
                            completion(.success(lesson))
                        } catch {
                            print("Failed to decode JSON: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                        completion(.failure(error))
                    }

                case .failure(let error):
                    print("Failed to create lesson: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
