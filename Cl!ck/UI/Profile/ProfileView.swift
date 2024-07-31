//
//  ProfileView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var showAlert = false
    @State private var navigateToOnboarding = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let Name: String
    let Grade: Int
    let Class: Int
    let Number: Int
    
    var body: some View {
        NavigationStack {
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
                    self.showAlert.toggle()
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("정말 회원탈퇴를 진행하시겠습니까?"),
                        message: Text("한번 진행하면 되돌릴수 없습니다."),
                        primaryButton: .default(
                            Text("예"),
                            action: {
                                navigateToOnboarding = true
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("아니요"),
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        )
                    )
                }
                
                NavigationLink(destination: OnBoardingView(), isActive: $navigateToOnboarding) {
                    EmptyView()
                }
                Spacer()
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                            Text("프로필")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    ProfileView(Name: "이다경", Grade: 2, Class: 2, Number: 4)
}
