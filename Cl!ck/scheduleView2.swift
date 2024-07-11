//
//  scheduleView2.swift
//  Cl!ck
//
//  Created by Junha on 6/20/24.
//

import SwiftUI
struct scheduleView2: View {
    @Binding var onClick: Bool
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 43)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                .foregroundColor(.red)
            Button {
                onClick = true
            } label: {
                VStack(alignment: .leading) {
                    Text("국어수행")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Text("국어실")
                        .font(.system(size: 13))
                        .foregroundColor(.gray400)
                }
            }
            Spacer()
                .frame(width: 270)
        }
    }
}
