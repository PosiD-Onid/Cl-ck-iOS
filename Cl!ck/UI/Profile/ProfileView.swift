//
//  ProfileView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct ProfileView: View {
    let Name: String
    let Grade: Int
    let Class: Int
    let Number: Int
    
    var body: some View {
            VStack {
                ZStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .frame(maxHeight: 260)
                    }
                    .padding(.top, 100)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            ProfileImage()
                            Spacer()
                        }
                        .padding(.bottom, 35)
                        
                        Text(Name)
                            .font(.system(size: 30, weight: .heavy))
                        Text("\(Grade)학년 \(Class)반 \(Number)번")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding(.horizontal, 35)
                }
                .padding(.bottom, 20)
                NavigationLink(destination: OnBoardingView()) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("로그아웃")
                        Spacer()
                    }
                    .font(.system(size: 20))
                    .padding(.leading)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button {
                } label: {
                    HStack {
                        Image(systemName: "nosign")
                        Text("회원탈퇴")
                        Spacer()
                    }
                    .padding(.leading)
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(
                VStack {
                    Rectangle()
                        .fill(Color.gray800.opacity(0.5))
                        .edgesIgnoringSafeArea(.top)
                        .frame(maxHeight: 300)
                    Rectangle()
                        .fill(Color.buttongary)
                        .edgesIgnoringSafeArea(.bottom)
                }
            )
    }
}


#Preview {
    ProfileView(Name: "이다경", Grade: 2, Class: 2, Number: 4)
}
