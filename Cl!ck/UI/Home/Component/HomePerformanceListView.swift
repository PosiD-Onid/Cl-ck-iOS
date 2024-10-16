import SwiftUI

struct HomePerformanceListView: View {
    @State private var showInformationDetailView: Performance? // 수정: 특정 Performance를 선택
    var selectedDate: Date?
    
    @State private var performances: [Performance] = []
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var errorMessage: String?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    
    private var formattedDate: String {
        guard let date = selectedDate else { return "" }
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Divider()
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            VStack {
                HStack {
                    Text("\(formattedDate)")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.leading, 20)
                    Spacer()
                }
                
                // Performances가 있는 경우에만 표시
                if performances.isEmpty {
                    Text("수행평가 일정이 없습니다.")
                        .font(.system(size: 21))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(performances.filter { Calendar.current.isDate($0.startDate!, inSameDayAs: selectedDate!) }) { performance in
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showInformationDetailView = performance // 클릭한 수행 평가를 보여줌
                            }
                        }) {
                            HomePerformanceCell(
                                title: performance.p_title,
                                place: performance.p_place,
                                startData: performance.startDate!
                            )
                        }
                        .padding(.leading, 20)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: 365)
        }
        .onAppear(perform: fetchPerformances)
        .overlay(
            Group {
                if let performance = showInformationDetailView {
                    InformationDetailView (
                        title: performance.p_title,
                        startDate: performance.startDate!,
                        place: performance.p_place,
                        endDate: performance.endDate!,
                        content: performance.p_content,
                        dismissAction: {
                            withAnimation(.easeInOut) {
                                showInformationDetailView = nil // dismiss
                            }
                        }
                    )
                    .background(Color.white)
                    .transition(.move(edge: .trailing))
                    .zIndex(0)
                }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
        }
    }
    
    private func fetchPerformances() {
        Service.shared.readPerformanceData { result in
            DispatchQueue.main.async {
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
}

#Preview {
    HomePerformanceListView(selectedDate: Date())
}
