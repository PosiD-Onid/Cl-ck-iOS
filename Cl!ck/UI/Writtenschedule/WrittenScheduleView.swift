//
//  WrittenScheduleView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct WrittenScheduleView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    ForEach(1..<10) { index in
                        WrittenScheduleCell()
                    }
                    .padding(.top)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("작성 일정")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TeacherPageView()) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    WrittenScheduleView()
}
