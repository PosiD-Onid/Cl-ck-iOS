import SwiftUI

struct WrittenScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedLesson: Lesson? // 선택된 수업을 저장
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if $viewModel.lessons.isEmpty {
                    Text("수업이 없습니다.")
                        .font(.title)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(viewModel.lessons) { lesson in
                            Button(action: {
                                selectedLesson = lesson
                            }) {
                                VStack(alignment: .leading) {
                                    Text(lesson.l_title)
                                        .font(.headline)
                                    Text(lesson.l_content)
                                        .font(.subheadline)
                                    Text("학년: \(lesson.l_grade), 반: \(lesson.l_class)")
                                        .font(.subheadline)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke())
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("수업목록")
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
                LessonCell(lesson: lesson) // 선택한 수업의 수행평가 보기
            }
        }
    }
}


#Preview {
    WrittenScheduleView()
}
