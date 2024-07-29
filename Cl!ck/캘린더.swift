import SwiftUI

struct MainView: View {
    @State private var selectedMonth = Date()
    @State private var selectedDate: Date?
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                calendarGridView
                    .padding(.horizontal)
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            HStack {
                Text(selectedMonth, formatter: Self.calendarHeaderDateFormatter)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .disabled(!canMoveToPreviousMonth())
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .disabled(!canMoveToNextMonth())
                
                NavigationLink(destination: AlarmView()) {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 20, height: 22)
                        .foregroundColor(.gray800)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray800, lineWidth: 1)
                        )
                }
            }
            .padding(.bottom, 20)
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { day in
                    Text(day.uppercased())
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Calendar Grid View
    private var calendarGridView: some View {
        let daysInMonth = numberOfDays(in: selectedMonth)
        let firstWeekday = firstWeekdayOfMonth(in: selectedMonth) - 1
        let rows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let extraDays = rows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday..<daysInMonth + extraDays, id: \.self) { index in
                Group {
                    if index >= 0 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        let isSelected = selectedDate == date
                        
                        CalendarCellView(day: day, isSelected: isSelected, isToday: isToday)
                            .onTapGesture { selectedDate = date }
                    } else {
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Cell View
private struct CalendarCellView: View {
    var day: Int
    var isSelected: Bool
    var isToday: Bool
    
    private var textColor: Color {
        if isToday {
            return .white
        } else if isSelected {
            return .black
        } else {
            return .black
        }
    }
    
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if isSelected {
            return Color.gray.opacity(0.5)
        } else {
            return .clear
        }
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 35, height: 35)
                .overlay(Text("\(day)").foregroundColor(textColor))
        }
        .frame(height: 100)
    }
}

private extension MainView {
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM"
        return formatter
    }()
    
    static let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        let firstDay = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedMonth), month: calendar.component(.month, from: selectedMonth), day: 1))!
        return calendar.date(byAdding: .day, value: index, to: firstDay)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    func changeMonth(by value: Int) {
        selectedMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth)!
    }
    
    func canMoveToPreviousMonth() -> Bool {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        return selectedMonth > threeMonthsAgo
    }
    
    func canMoveToNextMonth() -> Bool {
        let threeMonthsAhead = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        return selectedMonth < threeMonthsAhead
    }
}

#Preview {
    MainView()
}
