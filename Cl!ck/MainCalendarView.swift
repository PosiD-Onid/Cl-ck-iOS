//
//  MainCalenderView.swift
//  C!ick
//
//  Created by 이다경 on 4/11/24.
//

import Foundation
import SwiftUI
import Combine


struct TodayData: View {
    let currentDate = Date()
    @State private var draggedOffset = CGSize.zero
    @State private var isActive = false
    
    var body: some View {
        HStack {
            Text(getCurrentDate())
            Text(getDayOfWeek())
            Spacer()
                .frame(width: 300)
        }
        .font(.title3 .bold())
    }
    func getCurrentDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd."
            return dateFormatter.string(from: currentDate)
        }


    func getDayOfWeek() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: currentDate)
        }
}

struct MainCalendarView: View {
    @State private var onClick = true
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    let currentDate = Date()
    
    
    //임시
    @State private var isTapSideMenu = true
    
    init(
        selectedMonth: Date = Date(),
        selectedDate: Date? = nil
    ) {
        _selectedMonth = State(initialValue: selectedMonth)
        _selectedDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MainView()
                VStack {
                    Spacer()
                    if isTapSideMenu {
                        SideMenu(onClick: $onClick, isTapSideMenu: $isTapSideMenu)
                            .transition(.move(edge: .bottom))
                            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                            .padding(.top, 425)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    
    private struct ButtonView: View {
        var body: some View {
            VStack {
                Spacer()
                NavigationLink(destination: TPage()) {
                    HStack {
                        Spacer()
                        ZStack{
                            Circle()
                                .frame(width: 70)
                                .foregroundColor(.gray)
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        .shadow(radius: 10)
                        .padding()
                        Spacer()
                    }
                }
            }
        }
    }
    private var scheduleView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            Text("수행평가가 없습니다.")
            Spacer()
                .frame(width: 180)
        }
        .foregroundColor(.gray800.opacity(0.5))
    }
    
    struct scheduleView2: View {
        @Binding var onClick: Bool
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 5, height: 43)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .foregroundColor(.red)
                Button {
                    onClick = true
                } label: {
                    VStack(alignment: .leading) {
                        Text("국어수행")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Text("국어실")
                            .font(.system(size: 13))
                            .foregroundColor(.gray400)
                    }
                }
                Spacer()
                    .frame(width: 270)
            }
        }
    }
    
    struct Detailedschedule: View {
        @Binding var onClick: Bool
        var body: some View {
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.onClick = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.black)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            Circle()
                                .frame(width: 20)
                                .foregroundColor(.red)
                                .padding(.trailing)
                            Text("국어수행")
                                .font(.system(size: 20) .bold())
                        }
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                            Text("3월 19일 화요일")
                                .font(.system(size: 20))
                        }
                        HStack {
                            Image(systemName: "location")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                            Text("국어실")
                                .font(.system(size: 20))
                        }
                        HStack {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                            Text("하루 전")
                                .font(.system(size: 20))
                        }
                        HStack {
                            Image(systemName: "text.alignleft")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                            Text("내용")
                                .font(.system(size: 20))
                        }
                        Spacer()
                            .frame(width: 330)
                    }
                }
            }
        }
    }
    
    // MARK: - SideMenu
    public struct SideMenu: View {
        @Binding var onClick: Bool
        @Binding var isTapSideMenu: Bool
        
        var body: some View {
            VStack {
                Divider()
                if onClick {
                    Detailedschedule(onClick: $onClick)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 3)
                        .foregroundColor(Color.gray400)
                        .padding()
                    TodayData()
                    scheduleView2(onClick: $onClick)
                }
                Spacer()
                HStack {
                    ButtonView()
                        .frame(width:100, height:100)
                        .padding(.leading, 270)
                }
            }
            .background(.white)
            .onTapGesture {
                withAnimation {
                    isTapSideMenu.toggle()
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
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if clicked {
            return Color.gray.opacity(0.5)
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
        VStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            .frame(width: 35, height: 35)
            .overlay(Text(String(day)))
            .foregroundColor(textColor)
        }
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
