//
//  MyResultsList.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct MyResultsList: View {

    var body: some View {
        VStack {
            MyResultsListHeader()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(1..<19) { index in
                        MyResultsCell(subject: "인공지능 수학", result: 100)
                    }
                }
            }
        }
    }
}

#Preview {
    MyResultsList()
}
