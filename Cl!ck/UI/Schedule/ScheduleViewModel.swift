import SwiftUI
import Alamofire

class ScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var lessons: [Lesson] = []
    @Published var isLoading: Bool = true
    @Published var showLessonCreation: Bool = false
    
    init() {
        fetchLessons() // 뷰 모델 초기화 시 수업을 불러옵니다.
    }
    
    func fetchLessons() {
        // API 호출로 로그인한 선생님의 수업을 가져옵니다.
        guard let teacherId = UserDefaults.standard.string(forKey: "teacherId") else {
            self.isLoading = false
            return
        }
        
        let url = APIConstants.readLessonsURL(teacherId: teacherId)
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Lesson].self) { response in
                switch response.result {
                case .success(let lessons):
                    self.lessons = lessons
                    self.isLoading = false
                case .failure:
                    self.isLoading = false
                    self.lessons = []
                }
            }
    }
    
    func createLesson() {
        // 수업 생성하는 API 호출 (예시)
        // 이 함수는 네비게이션 링크와 연결되어 수업 생성 페이지로 이동합니다.
        self.showLessonCreation = true
    }
}
