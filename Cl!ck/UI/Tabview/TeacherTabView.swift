//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct TeacherTabView: View {

    var body: some View {
        NavigationView {
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
                TeachersProfileView(Name: "d", Subject: "국어국문학")
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
            .accentColor(.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TeacherTabView()
}
