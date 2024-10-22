import SwiftUI

struct HomeView: View {
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var isBViewVisible = false
    @State private var dragOffset = CGSize.zero
    @State private var bViewOffset = CGFloat(0)
    
    @State private var errorMessage: String?
    @State private var showAlert = false
    
    @State private var performances: [Performance] = []
    @State private var performanceDates: Set<Date> = []
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    CalendarGridView(
                        selectedMonth: $selectedMonth,
                        selectedDate: $selectedDate,
                        isBViewVisible: $isBViewVisible,
                        bViewOffset: $bViewOffset,
                        performanceDates: performanceDates,
                        performances: performances
                    )
                    .padding(.horizontal)
                    .frame(height: calendarGridHeight)
                    .frame(maxHeight: .infinity)
                    
                    if isBViewVisible {
                        HomePerformanceListView(selectedDate: selectedDate)
                            .frame(height: UIScreen.main.bounds.height / 2.5)
                            .offset(y: bViewOffset)
                            .transition(.move(edge: .bottom))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        if dragOffset.height > 0 {
                                            bViewOffset = dragOffset.height
                                        }
                                    }
                                    .onEnded { _ in
                                        if bViewOffset > 200 {
                                            hideBView()
                                        } else {
                                            withAnimation {
                                                bViewOffset = 0
                                            }
                                        }
                                    }
                            )
                            .animation(.spring(), value: bViewOffset)
                    }
                }
                
                WeekdaySymbolsView()
                    .background(Color.white)
                    .zIndex(1)
                    .padding(.top)
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(Self.calendarHeaderDateFormatter.string(from: selectedMonth))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(spacing: -10) {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                        }
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                }
            }
            .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        changeMonth(by: 1)
                    } else if value.translation.width > 50 {
                        changeMonth(by: -1)
                    } else if value.translation.height > 100 {
                        withAnimation {
                            isBViewVisible = false
                        }
                    }
                }
            )
            .navigationBarBackButtonHidden()
            .onAppear(perform: fetchPerformances)
        }
    }
    
    private func fetchPerformances() {
        Service.shared.readPerformanceData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let performances):
                    self.performances = performances
                    
                    for performance in performances {
                        if let startDate = performance.startDate {
                            self.performanceDates.insert(startDate)
                        }
                    }
                case .failure(let error):
                    self.errorMessage = "수행평가를 가져오는 데 실패했습니다: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
            fetchPerformances()
        }
    }
    
    private func showBView() {
        withAnimation {
            isBViewVisible = true
            bViewOffset = 0
        }
    }
    
    private func hideBView() {
        withAnimation {
            isBViewVisible = false
            bViewOffset = UIScreen.main.bounds.height
        }
    }
    
    private var calendarGridHeight: CGFloat {
        return isBViewVisible ? UIScreen.main.bounds.height / 2.5 : UIScreen.main.bounds.height / 2
    }
}

private extension HomeView {
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM"
        return formatter
    }()
}

#Preview {
    HomeView()
}
