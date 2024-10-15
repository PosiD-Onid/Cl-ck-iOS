//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct TeacherTabView: View {
    @State private var t_username: String = ""
    @State private var subject: String = ""
    @State private var t_userId: String = ""
    var userId: String

    var body: some View {
        NavigationView {
            TabView {
                LessonListView(userId: userId)
                    .tabItem {
                        Image(systemName: "tray")
                    }

                ProcessingResultsView()
                    .tabItem {
                        Image(systemName: "book")
                    }
                
                TeachersProfileView(username: t_username, userId: t_userId, subject: subject)
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
                if let profileData = data as? (String?, String?, String?, String?) {
                    self.t_username = profileData.1 ?? ""
                    self.t_userId = profileData.0 ?? ""
                    self.subject = profileData.3 ?? ""
                    
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
