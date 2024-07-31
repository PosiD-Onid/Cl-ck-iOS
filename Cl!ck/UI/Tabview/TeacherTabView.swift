//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct TeacherTabView: View {
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
                WrittenScheduleView()
                    .tabItem {
                        Image(systemName: "tray")
                    }
                ProcessingResultsView()
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
    TeacherTabView() // No arguments are needed here
}