//
//  ScheduleListView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct ScheduleListView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: InformationDetailView(
                        Title: "국어수행",
                        DetailDate: Date(),
                        Location: "국어실",
                        DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(),
                        Content: "수행평가내용", CircleColor: Color.green)
                    ) {
                        ScheduleCell(
                            Title: "국어수행",
                            Location: "국어실",
                            DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(),
                            CircleColor: Color.green
                        )
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 430)
            .background(Color.yellow)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    ScheduleListView()
}
