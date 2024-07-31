//
//  AlarmCell.swift
//  Cl!ck
//
//  Created by 이다경 on 7/23/24.
//

import SwiftUI

struct AlarmCell: View {
    let title : String
    let content : String
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 14)
                .foregroundColor(Color.main)
                .padding(.trailing, 7)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                Text(content)
                    .font(.system(size: 15))
            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    AlarmCell(title: "국어 수행평가 하루전", content: "국어 수행평가가 8월 19일에 있습니다.")
}
