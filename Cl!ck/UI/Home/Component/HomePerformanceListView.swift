import SwiftUI

struct HomePerformanceListView: View {
    @State private var showInformationDetailView: Performance?
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
                
                let (filteredPerformances, performanceCount) = filterPerformances(for: selectedDate, from: performances)
                
                if filteredPerformances.isEmpty {
                    Text("수행평가 일정이 없습니다.")
                        .font(.system(size: 21))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(filteredPerformances) { performance in
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        showInformationDetailView = performance
                                    }
                                }) {
                                    HStack {
                                        HomePerformanceCell(
                                            title: performance.p_title,
                                            place: performance.p_place,
                                            startData: performance.startDate!
                                        )
                                        .padding(.bottom, 8)
                                        .padding(.leading, 20)
                                        Spacer()
                                    }
                                }
                            }
                        }
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
                                showInformationDetailView = nil
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
