import SwiftUI

struct PerformanceListView: View {
    @State private var performances: [Performance] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var errorMessage: String?
    
    var lesson: Lesson? // 선택한 Lesson의 l_id를 사용하기 위해 var로 설정
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if performances.isEmpty {
                    Text("수행평가가 없습니다.")
                        .font(.title)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(performances) { performance in
                            PerformanceCell(
                                id: Int(performance.id),
                                title: performance.p_title,
                                place: performance.p_place,
                                content: performance.p_content,
                                startDate: performance.p_startdate,
                                endDate: performance.p_enddate,
                                lesson: lesson,
                                onEdit: { id in }
                            )
                        }
                    }
                }
            }
            .onAppear(perform: fetchPerformances)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 27)
                                .foregroundColor(.black)
                            Text("수행평가 목록")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PerformanceCreateView()) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류 발생"),
                      dismissButton: .default(Text("확인")))
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func fetchPerformances() {
        guard let lessonId = lesson?.id else {
                errorMessage = "수업 ID를 가져올 수 없습니다."
                showAlert = true
                isLoading = false
                return
            }
        
        Service.shared.readPerformances(lessonId: "\(lessonId)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let performances):
                    self.performances = performances
                case .failure(let error):
                    self.errorMessage = "수행평가를 가져오는 데 실패했습니다: \(error.localizedDescription)"
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
