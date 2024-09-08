//
//  TeacherTabScreenCotent.swift
//  Cl!ck
//
//  Created by 이다경 on 9/5/24.
//

import SwiftUI

struct StudentTabView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
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
            .accentColor(.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StudentTabView()
}
