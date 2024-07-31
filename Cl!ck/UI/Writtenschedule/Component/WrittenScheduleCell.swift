//
//  WrittenScheduleCell.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct WrittenScheduleCell: View {
    let title: String = "내가 읽은 책 소개하기 1회차"
    let data: String = "2099년 13월 45일 15교시"
    let grade: Int = 2
    let group: Int = 6
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                Text(data)
                    .font(.system(size: 15))
            }
            Spacer()
            Text("\(grade)학년 \(group)반")
                .font(.system(size: 15))
                .padding(.bottom)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 23)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .padding(.horizontal)
        )
    }
}

#Preview {
    WrittenScheduleCell()
}
