//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct C_ickTabView: View {
    @State private var selectedTab = 0
    
    //     UITabView 색상 초기화
    //        init() {
    //        UITabBar.appearance().backgroundColor = UIColor.white
    //
    //        }
    var body: some View {
        NavigationView {
            TabView {
                ProfileView(Name: "d", Grade: 2, Class: 2, Number: 4)
                    .tabItem {
                        Image(systemName: "house")
                        Text("달력")
                    }
                exff()
                    .tabItem {
                        Image(systemName: "tray")
                        Text("작성 일정")
                    }
                ChoosePageView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("성적처리")
                    }
                OnBoardingView()
                    .tabItem {
                        Label("사용자", systemImage: "person")
                    }
            }
            .font(.headline)
            .tint(Color.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    C_ickTabView() // No arguments are needed here
}
