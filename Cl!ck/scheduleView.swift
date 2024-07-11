//
//  scheduleView.swift
//  Cl!ck
//
//  Created by Junha on 6/27/24.
//

import SwiftUI

struct scheduleView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            Text("수행평가가 없습니다.")
            Spacer()
                .frame(width: 180)
        }
        .foregroundColor(.gray800)
    }
}
struct Detailedschedule: View {
    @Binding var onClick: Bool
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    self.onClick = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                        .foregroundColor(.black)
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 13) {
                    HStack {
                        Circle()
                            .frame(width: 20)
                            .foregroundColor(.red)
                            .padding(.trailing)
                        Text("국어수행")
                            .font(.system(size: 20) .bold())
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        Text("3월 19일 화요일")
                            .font(.system(size: 20))
                    }
                    HStack {
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        Text("국어실")
                            .font(.system(size: 20))
                    }
                    HStack {
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        Text("하루 전")
                            .font(.system(size: 20))
                    }
                    HStack {
                        Image(systemName: "text.alignleft")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        Text("내용")
                            .font(.system(size: 20))
                    }
                    Spacer()
                        .frame(width: 330)
                }
            }
        }
    }
}
