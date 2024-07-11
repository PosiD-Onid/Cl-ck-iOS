import SwiftUI

struct MainView: View {
    @State private var selectedMonth = Date() // 선택된 월을 저장하는 상태 변수
    @State private var selectedDate: Date? = nil // 선택된 날짜를 저장하는 상태 변수
    let currentDate = Date() // 현재 날짜를 저장
    let isTapSideMenu: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 200)
                VStack(spacing: 110) {
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                }
                Spacer()
            }
            VStack {
                Spacer()
                    .frame(height: 10)
                VStack (spacing: -15) {
                    VStack {
                        HStack(alignment: .center) {
                            Text(selectedMonth, formatter: Self.calendarHeaderDateFormatter)
                                .font(.title.bold())
                            Spacer()
                                .frame(width: 130)
                            Button {
                                changeMonth(by: -1)
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            .disabled(!canMoveToPreviousMonth())
                            
                            Button {
                                changeMonth(by: 1)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            .disabled(!canMoveToNextMonth())
                            .padding(.trailing)
                            
                            NavigationLink(destination: Alarm()) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 36, height: 35)
                                    .foregroundColor(Color.gray.opacity(0))
                                    .overlay(
                                        Image(systemName: "bell")
                                            .resizable()
                                            .foregroundColor(.gray)
                                            .frame(width: 20.42, height: 22.27)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.bottom, 20)
                        HStack {
                            ForEach(Self.weekdaySymbols, id: \.self) { day in
                                Text(day.uppercased())
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    CalendarGridView(selectedMonth: $selectedMonth, selectedDate: $selectedDate)
                    
                }
                Spacer()
                HStack {
                    Spacer()
                        .frame(width: 270)
                    ButtonView()
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private extension MainView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM"
        return formatter
    }()
    
    static let weekdaySymbols: [String] = ["일", "월", "화", "수", "목", "금", "토"]
}

private extension MainView {
    /// 선택된 월 변경
    func changeMonth(by value: Int) {
        self.selectedMonth = adjustedMonth(by: value)
    }
    
    /// 이전 월로 이동할 수 있는지 확인
    func canMoveToPreviousMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
        
        return adjustedMonth(by: -1) >= targetDate
    }
    
    /// 다음 월로 이동할 수 있는지 확인
    func canMoveToNextMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
        
        return adjustedMonth(by: 1) <= targetDate
    }
    
    /// 월을 추가하거나 빼서 조정된 날짜 가져오기
    func adjustedMonth(by value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? selectedMonth
    }
}

struct CalendarGridView: View {
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date?
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(generateCalendarCells(), id: \.self) { cell in
                CalendarCellView(
                    day: cell.day,
                    isToday: cell.isToday, isCurrentMonthDay: cell.isCurrentMonthDay,
                    onClick: {
                        if cell.isCurrentMonthDay {
                            selectedDate = cell.date
                        }
                    }(),
                    isTapSideMenu: false,;
                )
            }
        }
        .padding(.horizontal)
    }
    
    struct CalendarCell: Hashable {
        let day: Int
        let isCurrentMonthDay: Bool
        let isSelected: Bool
        let isToday: Bool
        let date: Date?
    }
    
    func generateCalendarCells() -> [CalendarCell] {
        let daysInMonth = numberOfDays(in: selectedMonth) // 현재 월의 일수
        let firstDayIndex = firstWeekdayOfMonth(in: selectedMonth) - 1 // 월의 첫 번째 요일 인덱스
        let daysInPreviousMonth = numberOfDays(in: previousMonth()) // 이전 월의 일수
        let numberOfRows = Int(ceil(Double(daysInMonth + firstDayIndex) / 7.0)) // 필요한 행 수 계산
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstDayIndex) // 다음 월의 가시적인 일수
        
        var cells: [CalendarCell] = []
        
        for index in 0..<(daysInMonth + firstDayIndex + visibleDaysOfNextMonth) {
            let cell: CalendarCell
            
            if index >= firstDayIndex && index < (daysInMonth + firstDayIndex) {
                let dayIndex = index - firstDayIndex
                let date = getDate(for: dayIndex)
                let day = Calendar.current.component(.day, from: date)
                let clicked = selectedDate == date
                let isToday = Calendar.current.isDate(date, inSameDayAs: today)
                
                cell = CalendarCell(day: day, isCurrentMonthDay: true, isSelected: clicked, isToday: isToday, date: date)
            } else {
                let day: Int
                if index < firstDayIndex {
                    day = daysInPreviousMonth - (firstDayIndex - index - 1)
                } else {
                    day = index - (daysInMonth + firstDayIndex) + 1
                }
                cell = CalendarCell(day: day, isCurrentMonthDay: false, isSelected: false, isToday: false, date: nil)
            }
            
            cells.append(cell)
        }
        
        return cells
    }
    
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    /// 특정 인덱스에 해당하는 날짜를 가져오기
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: selectedMonth),
                month: calendar.component(.month, from: selectedMonth),
                day: 1
            )
        ) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    /// 특정 날짜의 월에 있는 일 수 가져오기
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 특정 날짜의 월의 첫 번째 요일 가져오기
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 월의 날짜 가져오기
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        return Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    }
}

extension Date {
    static let calendarDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedDay: String {
        return Date.calendarDate.string(from: self)
    }
}
#Preview {
    MainView()
}
