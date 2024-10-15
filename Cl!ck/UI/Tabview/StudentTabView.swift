//
//  TeacherTabScreenCotent.swift
//  Cl!ck
//
//  Created by 이다경 on 9/5/24.
//

import SwiftUI

struct StudentTabView: View {
    @State private var s_username: String = ""
    @State private var userId: String = ""
    @State private var classof: Int = 0

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
                
                StudentsProfileView(username: s_username, userId: userId, classof: classof)
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
            .accentColor(.main)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadProfile()
        }
    }
    
    func loadProfile() {
        Service.shared.profile { result in
            switch result {
            case .success(let data):
                if let profileData = data as? (String, String?, String?, String?) {
                    self.s_username = profileData.2 ?? ""
                    self.userId = profileData.0
                    self.classof = Int(profileData.3 ?? "") ?? 0
                }
            case .pathErr:
                print("Path Error")
            case .networkFail:
                print("Network Failure")
            case .serverErr:
                print("Server Error")
            case .requestErr(let message):
                print("Request Error: \(message)")
            }
        }
    }
}

