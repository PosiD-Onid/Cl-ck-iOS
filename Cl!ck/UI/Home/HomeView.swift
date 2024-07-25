import Foundation
import SwiftUI

struct HomeView: View {
    @State private var selectedMonth: Date = Date() // 현재 선택된 월
    @State private var selectedDate: Date? // 현재 선택된 날짜

    // 초기값을 설정할 수 있는 사용자 정의 이니셜라이저
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
                DividerView // 구분선 뷰
                VStack {
                    Spacer()
                        .frame(height: 10) // 상단 여백
                    VStack(spacing: -15) {
                        headerView // 년도와 월, 요일 헤더를 표시하는 뷰
                        calendarGridView // 달력 그리드 뷰
                            .padding(.horizontal)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                            .frame(width: 270)
                        // ButtonView() // 추가 기능 버튼 뷰 (주석 처리됨)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true) // 내비게이션 바의 뒤로가기 버튼 숨기기
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            yearMonthView // 현재 년도와 월을 표시하고, 내비게이션 버튼 포함
                .padding(.bottom, 20)
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    Text(Self.weekdaySymbols[index].uppercased()) // 요일 헤더 표시
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - 구분선 뷰
    private var DividerView: some View {
        VStack {
            Spacer()
                .frame(height: 200) // 상단 여백
            VStack(spacing: 110) {
                Divider() // 구분선
                Divider()
                Divider()
                Divider()
                Divider()
            }
            Spacer()
        }
    }
    
    // MARK: - 년도와 월 뷰
    private var yearMonthView: some View {
        HStack(alignment: .center) {
            // 현재 선택된 월과 년도를 표시
            Text(selectedMonth, formatter: Self.calendarHeaderDateFormatter)
                .font(.title .bold())
            
            Spacer()
                .frame(width: 130)
            
            // 이전 월로 이동하는 버튼
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
            
            // 다음 월로 이동하는 버튼
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
            .padding(.trailing)
            
            // AlarmView로의 네비게이션 링크
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
    
    // MARK: - 달력 그리드 뷰
    private var calendarGridView: some View {
        let daysMonth: Int = numberOfDays(in: selectedMonth) // 선택된 월의 일 수
        let firstDay: Int = firstWeekdayOfMonth(in: selectedMonth) - 1 // 월의 첫 번째 날의 요일
        let lastDayMonthBefore = numberOfDays(in: previousMonth()) // 이전 월의 일 수
        let numberOfRows = Int(ceil(Double(daysMonth + firstDay) / 7.0)) // 그리드의 행 수
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysMonth + firstDay) // 표시할 다음 월의 일 수
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstDay ..< daysMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysMonth {
                        let date = getDate(for: index) // 현재 인덱스에 대한 날짜
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = selectedDate == date
                        let isToday = date.formattedDay == today.formattedDay
                        
                        CalendarCellView(day: day, clicked: clicked, isToday: isToday) // 각 날짜 셀 뷰
                        
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        CalendarCellView(day: day, isCurrentMonthDay: false) // 이전 월의 날짜 셀
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysMonth {
                        let date = getDate(for: index)
                        selectedDate = date // 선택된 날짜 업데이트
                    }
                }
            }
        }
    }
}

// MARK: - 셀 뷰
private struct CalendarCellView: View {
    private var day: Int // 일자
    private var clicked: Bool // 클릭된 상태
    private var isToday: Bool // 오늘 날짜 여부
    private var isCurrentMonthDay: Bool // 현재 월의 날짜 여부
    
    // 텍스트 색상을 상태에 따라 결정
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
    
    // 배경 색상을 상태에 따라 결정
    private var backgroundColor: Color {
        if isToday {
            return Color.black.opacity(0.7)
        } else if clicked {
            return Color.gray.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    
    // 오늘 날짜 배경 색상
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
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 35, height: 35)
                .overlay(Text(String(day))) // 날짜 숫자 표시
                .foregroundColor(textColor)
        }
        .frame(height: 100)
        .background(
            VStack {
                Spacer()
                    .frame(height: 52)
                Rectangle()
                    .frame(width: 52.7, height: 110)
                    .foregroundColor(rectangleColor)
            }
        )
        .onTapGesture(count: 2) {
            // 이중 탭 제스처
        }
    }
}

private extension HomeView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    // 날짜 포맷터: 년도와 월을 표시하는 포맷
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM"
        return formatter
    }()
    
    // 요일 심볼
    static let weekdaySymbols: [String] = ["일", "월", "화", "수", "목", "금", "토"]
}

private extension HomeView {
    /// 특정 인덱스에 대한 날짜를 반환합니다.
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
    
    /// 특정 날짜의 월에 포함된 일 수를 반환합니다.
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 특정 날짜의 월의 첫 번째 날의 요일을 반환합니다.
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 달의 첫 번째 날짜를 반환합니다.
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// 월을 변경합니다. (기본적으로 현재 선택된 월에 월 수를 추가 또는 빼기)
    func changeMonth(by value: Int) {
        self.selectedMonth = adjustedMonth(by: value)
    }
    
    /// 월을 조정한 날짜를 반환합니다. (월을 추가하거나 빼기)
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            return newMonth
        }
        return selectedMonth
    }
}

// MARK: - Date 확장
extension Date {
    static let calendarDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    // 날짜를 문자열 형식으로 반환합니다.
    var formattedDay: String {
        return Date.calendarDate.string(from: self)
    }
}

#Preview {
    HomeView()
}
