import Alamofire

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
            .responseDecodable(of: Lesson.self) { response in
                switch response.result {
                case .success(let lesson):
                    completion(.success(lesson))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
