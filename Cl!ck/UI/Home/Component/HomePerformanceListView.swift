import SwiftUI

struct HomePerformanceListView: View {
    @State private var showInformationDetailView = false
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
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showInformationDetailView = true
                        }
                    }) {
                        ForEach(performances) { performance in
                            HomePerformanceCell(
                                title: performance.p_title,
                                place: performance.p_place,
                                startData: Date() /*Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date()*/
                            )
                        }
                        //                            title: performance.p_title
                        //                            place: "국어실",
                        //                            startData: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date()
                        //                        )
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: 365)
        }
        .onAppear(perform: fetchPerformances)
        .overlay(
            Group {
                if showInformationDetailView {
                    ForEach(performances) { performance in
                        InformationDetailView (
                            title: performance.p_title,
                            startDate: Date(),
                            place: performance.p_place,
                            endDate: Date(),
                            content: performance.p_content,
                            dismissAction: {
                                withAnimation(.easeInOut) {
                                    showInformationDetailView = false
                                }
                            }
                        )
                        .background(Color.white)
                        .transition(.move(edge: .trailing))
                        .zIndex(0)
                    }
                } else {
                    Text("수행평가 일정이 없습니다.")
                        .font(.system(size: 21))
                        .foregroundColor(.gray)
                        .transition(.move(edge: .trailing))
                }
            }
        )
    }
    
    
    private func fetchPerformances() {
        let lessonId = 3
        
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
    HomePerformanceListView(selectedDate: Date())
}
