//
//  MainCalendarView.swift
//  C!ick
//
//  Created by 이다경 on 4/11/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var SelectedMonth: Date = Date()
    @State private var SelectedDate: Date?
    let currentDate = Date()
    
    init(
        SelectedMonth: Date = Date(),
        SelectedDate: Date? = nil
    ) {
        _SelectedMonth = State(initialValue: SelectedMonth)
        _SelectedDate = State(initialValue: SelectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DividerView
                VStack {
                    Spacer()
                        .frame(height: 10)
                    VStack(spacing: -15) {
                        headerView
                        calendarGridView
                            .padding(.horizontal)
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
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private struct ButtonView: View {
        var body: some View {
            VStack {
                Spacer()
                NavigationLink(destination: TeacherPageView()) {
                    HStack {
                        Spacer()
                        ZStack{
                            Circle()
                                .frame(width: 70)
                                .foregroundColor(.black.opacity(0.8))
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        .shadow(radius: 10)
                        Spacer()
                    }
                }
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
    
    // MARK: - DividerView
    private var DividerView: some View {
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
    }
    // MARK: - Year Month View
    private var yearMonthView: some View {
        HStack(alignment: .center) {
            
            Text(SelectedMonth, formatter: Self.calendarHeaderDateFormatter)
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
            
            NavigationLink(destination: AlarmView()) {
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
        let daysMonth: Int = numberOfDays(in: SelectedMonth)
        let firstday: Int = firstWeekdayOfMonth(in: SelectedMonth) - 1
        let lastDayMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysMonth + firstday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysMonth + firstday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstday ..< daysMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = SelectedDate == date
                        let isToday = date.formattedDay == today.formattedDay
                        
                        CalendarCellView(day: day, clicked: clicked, isToday: isToday)
                        
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        CalendarCellView(day: day, isCurrentMonthDay: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysMonth {
                        let date = getDate(for: index)
                        SelectedDate = date
                    }
                }
            }
        }
    }
}

// MARK: - Cell View
private struct CalendarCellView: View {
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
            return Color.clear
        }
    }
    //숫자 배경색 코드
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if clicked {
            return Color.gray.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    //오늘 날짜 배경색 코드
    private var rectangleColor: Color {
        if isToday {
            return Color.gray.opacity(0.2)
        } else {
            return Color.clear
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
//        var onClick: Bool = true
//        let isTapSideMenu: Bool = false
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 35, height: 35)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
        }
        .frame(height: 100)
        .background(
            VStack {
                Spacer()
                    .frame(height: 52)
                Rectangle()
                    .frame(width: 52.7,height: 110)
                    .foregroundColor(rectangleColor)
            }
        )
        .onTapGesture(count: 2) {
        }
    }
}

private extension HomeView {
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

private extension HomeView {
    /// Get date for a specific index
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: SelectedMonth),
                month: calendar.component(.month, from: SelectedMonth),
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
        let components = Calendar.current.dateComponents([.year, .month], from: SelectedMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// Change the selected month
    func changeMonth(by value: Int) {
        self.SelectedMonth = adjustedMonth(by: value)
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
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: SelectedMonth) {
            return newMonth
        }
        return SelectedMonth
    }
}

// MARK: - Extension for Date
extension Date {
    static let calendarDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedDay: String {
        return Date.calendarDayDate.string(from: self)
    }
}

#Preview {
    HomeView()
}
