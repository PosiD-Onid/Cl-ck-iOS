//
//  OnBoardingView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/23/24.
//

import SwiftUI

struct OnBoardingScreenContent: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    Image("C_ickLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    Divider()
                        .frame(height: 1)
                        .overlay(Color("gray400"))
                        .padding(.horizontal, 50)
                        .padding(.bottom)
                    
                    VStack(spacing: 4) {
                        Text("오직 학생들에 의한, 학생들을 위한")
                        Text("수행평가 일정관리 플랫폼 C!ick")
                    }
                    .font(.system(size: 21))
                    .foregroundColor(Color("gray800"))
                }
                .padding(.bottom, 200)
                Spacer()
                NavigationLink(destination: EntireSignInView()) {
                    Text("로그인")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color("MainColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                NavigationLink(destination: ChoosePageView()) {
                    Text("회원가입")
                        .foregroundStyle(Color.main)
                        .font(.system(size: 20, weight: .heavy))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.main, lineWidth: 2)
                        )
                        .cornerRadius(10)
                }
                .padding(.horizontal, 31)
                .padding(.bottom)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    OnBoardingScreenContent()
}
