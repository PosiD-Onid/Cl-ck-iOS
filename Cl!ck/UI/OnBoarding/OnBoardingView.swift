//
//  OnBoardingView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/23/24.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        GeometryReader{ geometryReader in
            NavigationView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometryReader.size.height / 8)
                    Image("ClickLogo")
                        .resizable()
                        .frame(width: geometryReader.size.width / 2.2, height: geometryReader.size.height / 9)
                    
                    Divider()
                        .frame(width: geometryReader.size.width / 1.4, height: 1)
                        .overlay(Color("gray400"))
                        .padding()
                    
                    VStack(alignment: .center) {
                        Text("오직 학생들에 의한, 학생들을 위한")
                        Text("수행평가 일정관리 플랫폼 C!ick")
                    }
                    .font(.system(size: geometryReader.size.width / 21))
                    .foregroundColor(Color("gray800"))
                    Spacer()
                        .frame(height: geometryReader.size.height / 2.2)
                    NavigationLink(destination: Choosepage()) {
                        HStack {
                            Text("시작하기")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.system(size: geometryReader.size.width / 23))
                        }
                        .frame(width: geometryReader.size.width / 1.2, height: geometryReader.size.height / 14)
                    }
                    .background(Color("MainColor"))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
