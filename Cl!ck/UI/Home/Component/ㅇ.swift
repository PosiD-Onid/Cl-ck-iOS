import SwiftUI

struct ExContent: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showDetails = false
    @State private var isAnimating = false

    var body: some View {
        VStack {
            headerView
            calendarView
            if showDetails {
                detailView
                    .transition(.move(edge: .bottom))
            } else {
                Spacer()
                if !isCurrentMonth {
                    todayButton
                }
            }
        }
        .gesture(DragGesture()
            .onEnded { value in
                if value.translation.width < -50 {
                    nextMonth()
                } else if value.translation.width > 50 {
                    previousMonth()
                } else if value.translation.height > 100 {
                    withAnimation {
                        showDetails = false
                    }
                }
            }
        )
    }
    
    // 상단 연도 및 월 표시
    var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "arrow.left")
            }
            Spacer()
            Text("\(formattedDate(date: currentMonth))")
                .font(.title)
            Spacer()
            Button(action: nextMonth) {
                Image(systemName: "arrow.right")
            }
        }
        .padding()
    }
    
    // 요일 및 날짜 표시
    var calendarView: some View {
        VStack {
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 5)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray),
                alignment: .bottom
            )
            
            let days = generateDays()
            let rows = days.count / 7
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: spacing(for: rows)) {
                ForEach(days.indices, id: \.self) { index in
                    if let date = days[index] {
                        dateView(date: date)
                            .onTapGesture {
                                withAnimation {
                                    selectedDate = date
                                    showDetails = true
                                    isAnimating = true
                                }
                            }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // 날짜 셀 뷰
    func dateView(date: Date) -> some View {
        VStack {
            Text("\(dayString(date: date))")
                .foregroundColor(dayColor(date: date))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(currentDateBackground(date: date))
                .cornerRadius(5)
        }
        .padding(.vertical, 5)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray),
            alignment: .top
        )
    }
    
    // 현재 날짜의 배경
    func currentDateBackground(date: Date) -> some View {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return AnyView(Color.gray.cornerRadius(5))
        } else {
            return AnyView(Color.clear)
        }
    }
    
    // 날짜 텍스트 색상
    func dayColor(date: Date) -> Color {
        let weekday = Calendar.current.component(.weekday, from: date)
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return .white
        } else if weekday == 1 {
            return .red
        } else if weekday == 7 {
            return .blue
        } else {
            return .black
        }
    }
    
    // 날짜의 날(day) 숫자
    func dayString(date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        return "\(day)"
    }
    
    // 연도와 월 형식화
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter.string(from: date)
    }
    
    // 월 변경
    func nextMonth() {
        withAnimation(.easeInOut) {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    func previousMonth() {
        withAnimation(.easeInOut) {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    // 현재 월인지 확인
    var isCurrentMonth: Bool {
        let current = Calendar.current
        return current.component(.year, from: currentMonth) == current.component(.year, from: Date()) &&
               current.component(.month, from: currentMonth) == current.component(.month, from: Date())
    }
    
    // 날짜 목록 생성
    func generateDays() -> [Date?] {
        var dates: [Date?] = []
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDayOfMonth = calendar.date(from: components) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 빈 날짜를 위해 nil 추가
        for _ in 0..<(firstWeekday - 1) {
            dates.append(nil)
        }
        
        // 실제 날짜 추가
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        
        // 남은 빈 날짜를 위해 nil 추가
        let remainingDays = (dates.count / 7 + (dates.count % 7 == 0 ? 0 : 1)) * 7 - dates.count
        for _ in 0..<remainingDays {
            dates.append(nil)
        }
        
        return dates
    }
    
    // 주 수에 따라 간격 조정
    func spacing(for rows: Int) -> CGFloat {
        return rows == 6 ? 5 : 15
    }
    
    // 현재 날짜로 이동 버튼
    var todayButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                currentMonth = Date()
                selectedDate = Date()
            }
        }) {
            Text("오늘 날짜로 이동")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
    
    // 2번 뷰
    var detailView: some View {
        VStack {
            Text("Details for \(dayString(date: selectedDate))")
                .padding()
            Spacer()
            Text("이곳에 상세 정보 표시")
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .offset(y: isAnimating ? 0 : UIScreen.main.bounds.height)
        .gesture(DragGesture()
            .onChanged { value in
                if value.translation.height > 50 {
                    withAnimation(.interactiveSpring()) {
                        showDetails = false
                        isAnimating = false
                    }
                }
            }
            .onEnded { value in
                if value.translation.height < 0 {
                    withAnimation(.interactiveSpring()) {
                        isAnimating = true
                    }
                }
            }
        )
    }
}

struct ExContent_Previews: PreviewProvider {
    static var previews: some View {
        ExContent()
    }
}
