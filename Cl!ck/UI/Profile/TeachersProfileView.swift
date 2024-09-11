//
//  ProfileView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct TeachersProfileView: View {
    @State private var showAlert = false
    @State private var navigateToOnboarding = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let Name: String
    let Subject: String
    
    var body: some View {
        NavigationView {
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
                        Text("\(Subject)")
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
    TeachersProfileView(Name: "이다경", Subject: "국어국문학")
}
