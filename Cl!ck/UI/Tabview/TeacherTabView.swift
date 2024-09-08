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
                ProfileView(Name: "d", Grade: 2, Class: 2, Number: 4)
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
