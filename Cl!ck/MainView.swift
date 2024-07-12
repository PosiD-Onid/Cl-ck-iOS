import SwiftUI

struct MainView: View {
    @State private var selectedMonth = Date() // 선택된 월을 저장하는 상태 변수
    @State private var selectedDate: Date? = nil // 선택된 날짜를 저장하는 상태 변수
    @State private var isTapSideMenu: Bool = false // 사이드 메뉴의 상태 변수
    let currentDate = Date() // 현재 날짜를 저장
    
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
                    
                    CalendarGridView(selectedMonth: $selectedMonth, selectedDate: $selectedDate, isTapSideMenu: $isTapSideMenu)
                    
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

#Preview {
    MainView()
}
