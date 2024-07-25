//
//  ScheduleCell.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct ScheduleCell: View {
    let Title: String
    let Location: String
    let DetailTime: Date
    let CircleColor: Color
    
    private var formattedTime: String {
        // 시간을 한국어로 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")  // 한국어 로케일
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: DetailTime)
    }
    
    var body: some View {
        HStack {
            HStack {
                Rectangle()
                    .foregroundColor(CircleColor)
                    .frame(maxWidth: 5, maxHeight: 50)
                    .cornerRadius(10)
                VStack(alignment: .leading, spacing: 5) {
                    Text(Title)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Text("\(formattedTime), \(Location)")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
    ScheduleCell(Title: "국어수행", Location: "국어실", DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(), CircleColor: Color.green.opacity(0.7))
}
