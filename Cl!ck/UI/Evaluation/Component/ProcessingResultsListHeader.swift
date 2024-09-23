//
//  ProcessingResultsListHeader.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

//
//  ProcessingGradesCell.swift
//  Cl!ck
//
//  Created by 이다경 on 7/31/24.
//

import SwiftUI

struct ProcessingResultsListHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
            HStack(spacing: 51) {
                Text("번호")
                Text("이름")
                Text("성적 입력")
                Text("확인 여부")
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.vertical)
            .padding(.leading)
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProcessingResultsListHeader()
}
