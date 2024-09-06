//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct TeacherTabScreenCotent: View {
    
    //    init() {
    //        UITabBar.appearance().backgroundColor = UIColor.white
    //    }
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
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
//            .font(.headline)
            .tint(Color.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TeacherTabView()
}
