import SwiftUI

struct CalendarView: View {
    @State private var month: Date = Date()
    @State private var selectedDay: Int? = nil
    @State private var selectedDays: [Int] = []
    
    let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            HStack {
                headerView
                Button(action: {
                    
                }) {
                    Image(systemName: "bell.fill")
                        .frame(width: 35, height: 35)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor,lineWidth:1)
                        )
                        .padding(.trailing, 25)
                }
            }
            weekDaysView
                .padding(.top, 10)
            calendarGridView
                .padding(.top, 15)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text("\(month, formatter: DateFormatter.monthAndYear)")
                .font(.headline)
            Spacer()
            Button(action: {
                changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }
    
    private var weekDaysView: some View {
        HStack {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(day == "일" ? .red : (day == "토" ? .blue : .black))
            }
        }
    }
    
    private var calendarGridView: some View {
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month))!
        let weekdayOfFirstDay = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let daysToPrepend = weekdayOfFirstDay - 1
        
        let totalDays = daysToPrepend + daysInMonth
        let rows = (totalDays / 7) + (totalDays % 7 == 0 ? 0 : 1)
        
        let days = (1..<(rows * 7 + 1)).map { Day(id: $0, day: $0) }
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
            ForEach(days) { day in
                if day.id > daysToPrepend && day.id <= daysToPrepend + daysInMonth {
                    let dayNumber = day.id - daysToPrepend
                    Button(action: {
                        if let firstSelectedDay = selectedDays.first, selectedDays.count == 1 {
                            // 이미 하나의 날짜가 선택되어 있고, 사용자가 두 번째 날짜를 선택한 경우
                            if dayNumber > firstSelectedDay {
                                selectedDays = Array(firstSelectedDay...dayNumber)
                            } else {
                                selectedDays = Array(dayNumber...firstSelectedDay)
                            }
                        } else {
                            // 아직 선택된 날짜가 없거나, 이미 범위가 선택된 경우 새로운 범위 선택 시작
                            selectedDays = [dayNumber]
                        }
                    }) {
                        VStack {
                            Text("\(dayNumber)")
                                .foregroundColor(Calendar.current.isDateInToday(Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: firstDayOfMonth)!) ? .white : dayOfWeekColor(day.id - daysToPrepend, firstDayOfWeek: weekdayOfFirstDay))
                        }
                        .frame(width: 50, height: 50)
                        .background(
                            selectedDays.contains(dayNumber) ?
                            RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)) :
                                (Calendar.current.isDateInToday(Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: firstDayOfMonth)!) ?
                                 RoundedRectangle(cornerRadius: 10).fill(Color.gray) :
                                    RoundedRectangle(cornerRadius: 0).fill(Color.clear))
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    private func dayOfWeekColor(_ day: Int, firstDayOfWeek: Int) -> Color {
        let totalOffset = (firstDayOfWeek - 1 + day - 1) % 7
        return totalOffset == 0 ? .red : (totalOffset == 6 ? .blue : .black)
    }
    
    
    
    private func changeMonth(by amount: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: amount, to: month) {
            month = newMonth
            selectedDay = nil
        }
    }
}

extension DateFormatter {
    static let monthAndYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

struct Day: Identifiable {
    var id: Int
    var day: Int
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

