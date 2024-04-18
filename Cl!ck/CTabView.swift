//
//  TabView.swift
//  Cl!ck
//
//  Created by Junha on 4/18/24.
//

import SwiftUI

struct CTabView: View {
    var body: some View {
        TabView {
            AlarmView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            Text("SettingView")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
        }
        .font(.headline)
    }
}

#Preview {
    CTabView()
}
