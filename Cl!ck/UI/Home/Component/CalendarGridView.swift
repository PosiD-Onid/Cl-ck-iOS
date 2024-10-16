import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date?
    @Binding var isBViewVisible: Bool
    @Binding var bViewOffset: CGFloat
    var performanceDates: Set<Date>
    
    var body: some View {
        let days = generateDays(for: selectedMonth)
        let numberOfWeeks = calculateNumberOfWeeks(for: selectedMonth)
        let cellHeight: CGFloat = isBViewVisible ? (numberOfWeeks == 5 ? 55.7 : 46.4) : (numberOfWeeks == 5 ? 114 : 95)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
            ForEach(Array(days.enumerated()), id: \.offset) { (index, date) in
                Group {
                    if let date = date {
                        let day = Calendar.current.component(.day, from: date)
                        let isToday = Calendar.current.isDate(date, inSameDayAs: today)
                        let isSelected = selectedDate == date
                        let weekday = Calendar.current.component(.weekday, from: date)
                        
                        ZStack {
                            CalendarCellView(
                                day: day,
                                clicked: isSelected,
                                isToday: isToday,
                                cellHeight: cellHeight,
                                isBViewVisible: isBViewVisible,
                                weekday: weekday
                            )
                            
                            if performanceDates.contains(Calendar.current.startOfDay(for: date)) {
                                Circle()
                                    .fill(Color.main) // 색상 설정
                                    .frame(width: 8, height: 8)
                                    .offset(y: -12) // 위치 조정
                            }
                        }
                        
                    } else {
                        CalendarCellView(
                            day: 0,
                            isCurrentMonthDay: false,
                            cellHeight: cellHeight,
                            isBViewVisible: isBViewVisible,
                            weekday: 0
                        )
                    }
                }
                .onTapGesture {
                    if let date = date, Calendar.current.component(.day, from: date) > 0 {
                        selectedDate = date
                        showBView()
                    }
                }
            }
        }
    }
    
    private func generateDays(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var dates: [Date?] = []
        
        for _ in 1..<firstWeekday {
            dates.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        let totalDays = dates.count
        let numberOfDaysToFill = (totalDays % 7 == 0) ? 0 : 7 - (totalDays % 7)
        for _ in 0..<numberOfDaysToFill {
            dates.append(nil)
        }
        
        return dates
    }
    
    private func calculateNumberOfWeeks(for date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return 0 }
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let totalDays = range.count
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let totalDaysNeeded = totalDays + (firstWeekday - 1)
        return (totalDaysNeeded + 6) / 7
    }
    
    private func showBView() {
        withAnimation {
            isBViewVisible = true
            bViewOffset = 0
        }
    }
    
    private var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
}
