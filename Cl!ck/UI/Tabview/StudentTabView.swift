//
//  StudentTabView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//


import SwiftUI

struct StudentTabView: View {
    @State private var selectedTab = 0
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.white
//    }
    var body: some View {
        NavigationView {
            TabView {
                ProfileView(Name: "d", Grade: 2, Class: 2, Number: 4)
                    .tabItem {
                        Image(systemName: "house")
                    }
                MyResultsView()
                    .tabItem {
                        Image(systemName: "book")
                    }
                ProfileView(Name: "d", Grade: 2, Class: 2, Number: 4)
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
            .font(.headline)
            .tint(Color.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StudentTabView()
}
