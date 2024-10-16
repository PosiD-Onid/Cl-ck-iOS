//
//  MyResultsList.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct MyResultsView: View {

    var body: some View {
        NavigationView {
            VStack {
                MyResultsListHeader()
                    .padding(.top, 5)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(1..<19) { index in
                            MyResultsCell(subject: "인공지능 수학", result: 100)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("내 성적 모아보기")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    MyResultsView()
}
