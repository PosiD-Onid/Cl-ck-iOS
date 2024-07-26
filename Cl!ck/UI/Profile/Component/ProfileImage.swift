//
//  ProfileImage.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct ProfileImage: View {
    var body: some View {
        Image("ProfileImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 180)
    }
}

#Preview {
    ProfileImage()
}
