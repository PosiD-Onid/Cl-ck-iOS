//
//  AlarmView.swift
//  Cl!ck
//
//  Created by Junha on 4/18/24.
//

import SwiftUI

struct AlarmView: View {
    @State private var isCalendarViewActive = false
    // 벨 아이콘 상태를 추적하기 위한 상태 변수 추가
    @State private var isAlarmActive = true

    var body: some View {
        NavigationView {
            List {
                NotificationRow(suhang: "국어", remain: 24)
                NotificationRow(suhang: "웹프", remain: 5)
            }
            .navigationBarTitle("알람", displayMode: .inline)
            .navigationBarItems(leading: HStack {
                // CalendarView로 이동하는 버튼
                Button(action: {
                    self.isCalendarViewActive = true
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
                .background(NavigationLink(destination: CalendarView(), isActive: $isCalendarViewActive) { EmptyView() }.hidden())
                
                Spacer().frame(width: 30)
                Text("알람")
            }, trailing: Button(action: {
                // 벨 아이콘 클릭 시 상태 변경
                self.isAlarmActive.toggle()
            }) {
                Image(systemName: isAlarmActive ? "bell.fill" : "bell.slash.fill")
                    .foregroundColor(.accentColor) // 아이콘 색상 조정
                    .padding(5) // 아이콘 주변 패딩 추가
                    .background(Color.clear) // 배경색 투명 설정
                    .clipShape(RoundedRectangle(cornerRadius: 5)) // 모서리 둥글게
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.accentColor, lineWidth: 2) // 보더 설정
                    )
            }
                .padding(.trailing, 20)
                .padding(.top, 20)
            )
        }
    }
}

struct NotificationRow: View {
    var suhang: String
    var remain: Int
    
    var body: some View {
        HStack {
            Image(systemName:"circle.fill")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text("\(suhang) 수행평가 \(remain)시간 전")
                    .font(.headline)
                Text("\(suhang) 수행평가가 \(remain)시간 후에 시작합니다.")
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
