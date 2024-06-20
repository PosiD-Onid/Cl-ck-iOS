//
//  Alarm.swift
//  C!ick
//
//  Created by 이다경 on 4/11/24.
//

import Foundation
import SwiftUI

struct Alarm: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            AlarmheadView
                .padding(.leading)
            VStack(alignment: .leading, spacing: 3) {
                AlarmView
                Divider()
                AlarmView
                Divider()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var AlarmheadView: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                    .font(.system(size: 33))
                Text("알람")
                    .font(.title .bold())
                    .foregroundColor(.black)
            }
        }
    }
    
    private var AlarmView: some View {
        HStack {
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: 10)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text("웹프 수행평가 제출 3시간전")
                    .font(.system(size: 15) .bold())
                Text("웹프 수행평가 제출이 오후 11시 59분에 마감됩니다.")
                    .font(.system(size: 13))
            }
        }
        .padding()
    }
}

#Preview {
    Alarm()
}
