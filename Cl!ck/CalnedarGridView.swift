import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date?
    @Binding var isTapSideMenu: Bool

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(generateCalendarCells(), id: \.self) { cell in
                CalendarCellView(
                    day: cell.day,
                    isToday: cell.isToday,
                    isCurrentMonthDay: cell.isCurrentMonthDay,
                    onClick: {
                        if cell.isCurrentMonthDay {
                            selectedDate = cell.date
                        }
                    }(),
                    isTapSideMenu: $isTapSideMenu
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
