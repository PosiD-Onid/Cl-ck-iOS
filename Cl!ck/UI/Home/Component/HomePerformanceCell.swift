//
//  ScheduleCell.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct HomePerformanceCell: View {
    let title: String
    let place: String
    let startData: Date
    
    private var formattedTime: String {
        // 시간을 한국어로 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: startData)
    }
    
    var body: some View {
//        ScrollView {
            HStack {
                Rectangle()
                    .foregroundColor(Color.main.opacity(0.7))
                    .frame(maxWidth: 5, maxHeight: 50)
                    .cornerRadius(10)
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Text("\(formattedTime), \(place)")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
            }
//        }
    }
}

#Preview {
    HomePerformanceCell(title: "국어수행", place: "국어실", startData: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date())
}
