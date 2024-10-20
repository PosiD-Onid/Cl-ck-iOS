import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date?
    @Binding var isBViewVisible: Bool
    @Binding var bViewOffset: CGFloat
    var performanceDates: Set<Date>
    var performances: [Performance]

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

                            let (filteredPerformances, performanceCount) = filterPerformances(for: date, from: performances)

                            if performanceCount > 0 {
                                if isBViewVisible {
                                    VStack {
                                        Spacer()
                                        HStack(spacing: 1.5) {
                                            ForEach(0..<performanceCount, id: \.self) { _ in
                                                Circle()
                                                    .fill(Color.main)
                                                    .frame(maxWidth: 7.5)
                                            }
                                        }
                                        .offset(y: 4)
                                    }
                                } else {
                                    VStack(alignment: .leading, spacing: 1.5) {
                                        ForEach(filteredPerformances.prefix(2), id: \.id) { performance in
                                            HStack(spacing: 2) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundStyle(Color.main)
                                                    .frame(maxWidth: 3, maxHeight: 15)
                                                Text(performance.p_title)
                                                    .font(.system(size: 10))
                                            }
                                        }
                                    }
                                }
                                    
//                                } else {
//                                    VStack {
//                                        HStack(spacing: 5) {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .foregroundStyle(Color.main)
//                                                .frame(maxWidth: 3, maxHeight: 15)
//                                            Text("국어수행")
//                                                .font(.system(size: 10))
//                                        }
//                                    }
//                                    .padding(.top)
//                                }
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
