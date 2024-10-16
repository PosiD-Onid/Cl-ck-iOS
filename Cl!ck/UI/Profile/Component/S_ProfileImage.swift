//
//  ProfileImage.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct S_ProfileImage: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(height: 172)
            Circle()
                .frame(height: 170)
                .foregroundColor(.white)
                Image(systemName: "studentdesk")
                    .resizable()
                    .frame(width: 68, height: 75)
        }
    }
}

#Preview {
    S_ProfileImage()
}
