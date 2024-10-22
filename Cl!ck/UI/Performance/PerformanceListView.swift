import SwiftUI

struct PerformanceListView: View {
    @State private var performances: [Performance] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var errorMessage: String?
    
    var lesson: Lesson?
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
                        if let lesson = lesson {
                            HStack {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(lesson.l_content)
                                        .font(.system(size: 24))
                                        .multilineTextAlignment(.leading)
                                        .bold()
                                    Text("\(lesson.l_year) \(lesson.l_semester)학기")
                                }
                                .padding(.leading)
                                .padding([.leading, .bottom])
                                Spacer()
                            }
                            .frame(width: .infinity, height: 150)
                            .background(Color.pIn)
                        }
                        ForEach(performances) { performance in
                            PerformanceCell(
                                id: Int(performance.id),
                                title: performance.p_title,
                                place: performance.p_place,
                                content: performance.p_content,
                                startDate: performance.startDate!,
                                endDate: performance.endDate!,
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
                            if let lesson = lesson {
                                Text("\(lesson.l_title)_\(lesson.l_grade)학년\(lesson.l_class)반")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.leading)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PerformanceCreateView(lesson: lesson)) {
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

    private func getPeriod(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        switch (hour, minute) {
        case (8, 50): return "1교시"
        case (9, 50): return "2교시"
        case (10, 50): return "3교시"
        case (11, 50): return "4교시"
        case (13, 30): return "5교시"
        case (14, 30): return "6교시"
        case (15, 30): return "7교시"
        default: return "시간 정보 없음"
        }
    }
}
