import SwiftUI
import Alamofire

struct LessonListView: View {
    @State private var lessons: [Lesson] = []  // 여러 개의 수업 데이터를 저장하는 배열
    @State private var isLoading = true
    @State private var selectedLesson: Lesson? // 선택된 수업을 저장
    @State private var showAlert = false
    @State private var errorMessage: String? // 에러 메시지 저장

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
                            PerformanceListView(
                                id: UUID(uuidString: "\(lesson.id)") ?? UUID(),
                                title: lesson.l_title,
                                data: lesson.l_content,
                                grade: Int(lesson.l_grade) ?? 0,
                                group: Int(lesson.l_class) ?? 0,
                                onEdit: { id in
                                },
                                onDelete: { id in
                                }
                            )
                            .onTapGesture {
                                selectedLesson = lesson
                            }
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
                    NavigationLink(destination: LessonCreateView()) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(item: $selectedLesson) { lesson in
                LessonCell(lesson: lesson)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func fetchLessons() {
        // 실제 사용자 ID를 넣어야 합니다.
        let teacherId = "qwe"

        Service.shared.readLessons(teacherId: teacherId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let lessons):
                    self.lessons = lessons // 서버에서 반환된 모든 수업 데이터를 배열로 저장
                case .failure(let error):
                    self.errorMessage = "수업을 가져오는 데 실패했습니다: \(error.localizedDescription)"
                    self.showAlert = true
                }
                self.isLoading = false
            }
        }
    }
}

#Preview {
    LessonListView()
}
