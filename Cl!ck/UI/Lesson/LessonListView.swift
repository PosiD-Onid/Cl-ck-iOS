import SwiftUI
import Alamofire

struct LessonListView: View {
    @State private var lessons: [Lesson] = []
    @State private var isLoading = true
    @State private var selectedLesson: Lesson?
    @State private var showAlert = false
    @State private var errorMessage: String?
//    @State private var userId: String?
    var userId: String
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if lessons.isEmpty {
                    Text("수업이 없습니다.")
                        .font(.title)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(lessons) { lesson in
                            NavigationLink(
                                destination: PerformanceListView(lesson: lesson),
                                label: {
                                    LessonCell(
                                        id: Int(lesson.id),
                                        title: lesson.l_title,
                                        data: lesson.l_content,
                                        grade: Int(lesson.l_grade) ?? 0,
                                        group: Int(lesson.l_class) ?? 0,
                                        semester: Int(lesson.l_semester) ?? 1,
                                        year: Int(lesson.l_year) ?? 0,
                                        place: lesson.l_place,
                                        userId: userId,
                                        onEdit: { id in }
                                    )
                                }
                            )
                        }
                    }
                }
            }
            .onAppear(perform: fetchLessons)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("수업 목록")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: LessonCreateView(userId: userId)) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func fetchLessons() {
        Service.shared.readLessons(teacherId: userId) { result in
            switch result {
            case .success(let lessons):
                self.lessons = lessons
            case .failure(let error):
                self.errorMessage = "수업을 가져오는 데 실패했습니다: \(error.localizedDescription)"
                self.showAlert = true
            }
            self.isLoading = false
        }
    }
}

#Preview {
    LessonListView(userId: "sad")
}
