//
//  MyResultsListHeader.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct MyResultsListHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
            HStack {
                Text("과목명")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                Text("점수")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("성적 확인")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 40)
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.vertical)
            Divider()
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    MyResultsListHeader()
//}
#Preview {
    MyResultsList()
}
