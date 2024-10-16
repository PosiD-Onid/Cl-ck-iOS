import SwiftUI
import Alamofire

struct LessonListView: View {
    @State private var lessons: [Lesson] = []
    @State private var performances: [Performance] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var errorMessage: String?
    var userId: String

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if lessons.isEmpty {
                    Text("수업이 없습니다.")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 15) {
                            ForEach(lessons) { lesson in
                                let hasPerformance = performances.contains { $0.l_id == lesson.id }
                                NavigationLink(
                                    destination: PerformanceListView(lesson: lesson)
                                        .onAppear {
                                            fetchPerformances(for: lesson.id)
                                        },
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
                                            hasPerformance: hasPerformance,
                                            onEdit: { id in }
                                        )
                                        .frame(maxWidth: .infinity)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
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
        .navigationBarBackButtonHidden(true)
    }

    private func fetchLessons() {
        Service.shared.readLessons(teacherId: userId) { result in
            switch result {
            case .success(let lessons):
                self.lessons = lessons
                self.fetchAllPerformances() // 모든 수행평가를 한 번에 가져옴
            case .failure(let error):
                self.errorMessage = "수업을 가져오는 데 실패했습니다: \(error.localizedDescription)"
                self.showAlert = true
            }
            self.isLoading = false
        }
    }
        
    private func fetchAllPerformances() {
        let lessonIds = lessons.map { "\($0.id)" }
        let group = DispatchGroup()
        
        for lessonId in lessonIds {
            group.enter()
            Service.shared.readPerformances(lessonId: lessonId) { result in
                switch result {
                case .success(let performances):
                    self.performances.append(contentsOf: performances)
                case .failure(let error):
                    self.errorMessage = "수행평가를 가져오는 데 실패했습니다: \(error.localizedDescription)"
                    self.showAlert = true
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func fetchPerformances(for lessonId: Int) {
        Service.shared.readPerformances(lessonId: "\(lessonId)") { result in
            switch result {
            case .success(let performances):
                self.performances = performances
            case .failure(let error):
                self.errorMessage = "수행평가를 가져오는 데 실패했습니다: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}
