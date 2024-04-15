//
//  MainCalenderView.swift
//  C!ick
//
//  Created by 이다경 on 4/11/24.
//

import Foundation
import SwiftUI

struct MainCalendarView: View {
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    
    init(
        selectedMonth: Date = Date(),
        selectedDate: Date? = nil
    ) {
        _selectedMonth = State(initialValue: selectedMonth)
        _selectedDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            NavigationView {
                calendarGridView
                    .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            yearMonthView
                .padding(.bottom, 20)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    Text(Self.weekdaySymbols[index].uppercased())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Year Month View
    private var yearMonthView: some View {
        HStack(alignment: .center) {
            
            Text(selectedMonth, formatter: Self.calendarHeaderDateFormatter)
                .font(.title .bold())
            
            Spacer()
                .frame(width: 130)
            
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            )
            .disabled(!canMoveToPreviousMonth())
            
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            )
            .disabled(!canMoveToNextMonth())
            .padding(.trailing)
            
            NavigationLink(destination: Alarm()) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 36, height: 35)
                    .foregroundColor(Color.gray.opacity(0))
                    .overlay(
                        Image(systemName: "bell")
                            .resizable()
                            .foregroundColor(.gray800)
                            .frame(width: 20.42, height: 22.27)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray800, lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Calendar Grid View
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: selectedMonth)
        let firstWeekday: Int = firstWeekdayOfMonth(in: selectedMonth) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = selectedDate == date
                        let isToday = date.formattedCalendarDay == today.formattedCalendarDay
                        
                            CellView(day: day, clicked: clicked, isToday: isToday)
                        
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                            CellView(day: day, isCurrentMonthDay: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        selectedDate = date
                    }
                }
            }
        }
    }
}

// MARK: - Cell View
private struct CellView: View {
    @State private var isAnimation = false
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var textColor: Color {
        if isToday {
            return Color.white
        } else if clicked {
            return Color.black
        } else if isCurrentMonthDay {
            return Color.black
        } else {
            return Color.white
        }
    }
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if clicked {
            return Color.gray.opacity(0.5)
        } else {
            return Color.white
        }
    }
    private var RectangleColor: Color {
        if isToday {
            return Color.gray.opacity(0.4)
        } else {
            return Color.white
        }
    }

    fileprivate init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }

    fileprivate var body: some View {
        VStack {
            Divider()
                .frame(width: 53.2, height: 0.5)
                .background(.gray800)
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 35, height: 35)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
            Spacer()
                .frame(height: 88)
        }
        .frame(height: isAnimation ? 35 : 120)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.white, lineWidth: 0.5)
                .frame(width: 52.5, height: 131)
                .background(RectangleColor)
        )
    }
}

private extension MainCalendarView {
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

private extension MainCalendarView {
    /// Get date for a specific index
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
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    /// Get the number of days in a month
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// Get the weekday of the first day of a month
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// Get the date of the previous month
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// Change the selected month
    func changeMonth(by value: Int) {
        self.selectedMonth = adjustedMonth(by: value)
    }
    
    /// Check if moving to the previous month is possible
    func canMoveToPreviousMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
        
        if adjustedMonth(by: -1) < targetDate {
            return false
        }
        return true
    }
    
    /// Check if moving to the next month is possible
    func canMoveToNextMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
        
        if adjustedMonth(by: 1) > targetDate {
            return false
        }
        return true
    }
    
    /// Get the adjusted month after adding or subtracting months
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            return newMonth
        }
        return selectedMonth
    }
}

// MARK: - Extension for Date
extension Date {
    static let calendarDayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDay: String {
        return Date.calendarDayDate.string(from: self)
    }
}




#Preview {
    MainCalendarView()
}
