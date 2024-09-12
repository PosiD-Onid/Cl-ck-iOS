//
//  SfidaTabView.swift
//  sfida
//
//  Created by dgsw8th61 on 7/16/24.
//

import SwiftUI

struct TeacherTabView: View {
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) { // 현재 선택된 탭 상태 바인딩
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0) // HomeView의 탭 인덱스
                
                LessonListView()
                    .tabItem {
                        Image(systemName: "tray")
                    }
                    .tag(1) // LessonListView의 탭 인덱스

                ProcessingResultsView()
                    .tabItem {
                        Image(systemName: "book")
                    }
                    .tag(2) // 다른 탭 인덱스
                
                TeachersProfileView(Name: "d", Subject: "국어국문학")
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3) // 다른 탭 인덱스
            }
            .accentColor(.main)
        }
        .navigationBarBackButtonHidden(true)
    }
}
