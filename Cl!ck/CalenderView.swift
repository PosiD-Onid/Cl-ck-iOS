//
//  Calender.swift
//  Cl!ck
//
//  Created by Junha on 4/4/24.
//

import SwiftUI

struct CalenderView: View {
  @State var month: Date
  @State var offset: CGSize = CGSize()
  @State var clickedDates: Set<Date> = []
  
  var body: some View {
    VStack {
      headerView
      calendarGridView
    }
    .gesture(
      DragGesture()
        .onChanged { gesture in
          self.offset = gesture.translation
        }
        .onEnded { gesture in
          if gesture.translation.width < -100 {
            changeMonth(by: 1)
          } else if gesture.translation.width > 100 {
            changeMonth(by: -1)
          }
          self.offset = CGSize()
        }
    )
  }
  
  // MARK: - 헤더 뷰
  private var headerView: some View {
    VStack {
      Text(month, formatter: Self.dateFormatter)
        .font(.title)
        .padding(.bottom)
      
      HStack {
        ForEach(Self.weekdaySymbols, id: \.self) { symbol in
          Text(symbol)
            .frame(maxWidth: .infinity)
        }
      }
      .padding(.bottom, 5)
    }
  }
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
      let daysInMonth: Int = numberOfDays(in: month)
      let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1

      return VStack(spacing: 10) { // 여기에 VStack의 간격을 10으로 설정
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 15) { // 열 간격을 10, 행 간격을 15로 설정
          ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
            if index < firstWeekday {
              RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.clear)
            } else {
              let date = getDate(for: index - firstWeekday)
              let day = index - firstWeekday + 1
              let clicked = clickedDates.contains(date)
              
              CellView(day: day, clicked: clicked)
                .onTapGesture {
                  if clicked {
                    clickedDates.remove(date)
                  } else {
                    clickedDates.insert(date)
                  }
                }
            }
          }
        }
      }
    }

}

// MARK: - 일자 셀 뷰
private struct CellView: View {
  var day: Int
  var clicked: Bool = false
  
  init(day: Int, clicked: Bool) {
    self.day = day
    self.clicked = clicked
  }
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 5)
        .opacity(0)
        .overlay(Text(String(day)))
        .foregroundColor(.blue)
      
      if clicked {
        Text("Click")
          .font(.caption)
          .foregroundColor(.red)
      }
    }
  }
}

// MARK: - 내부 메서드
private extension CalenderView {
  /// 특정 해당 날짜
  private func getDate(for day: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
  }
  
  /// 해당 월의 시작 날짜
  func startOfMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: month)
    return Calendar.current.date(from: components)!
  }
  
  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
  
  /// 월 변경
  func changeMonth(by value: Int) {
    let calendar = Calendar.current
    if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
      self.month = newMonth
    }
  }
}

// MARK: - Static 프로퍼티
extension CalenderView {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    // "MMMM yyyy"에서 "yyyy.MM"으로 변경
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()
  
  static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

#Preview {
    CalenderView(month: Date())
}
