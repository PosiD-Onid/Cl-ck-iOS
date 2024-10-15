//
//  T_ProfileImage.swift
//  Cl!ck
//
//  Created by 이다경 on 10/11/24.
//

import Foundation
import SwiftUI

struct T_ProfileImage: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(height: 182)
            Circle()
                .frame(height: 180)
                .foregroundColor(.white)
                Image(systemName: "rectangle.inset.filled.and.person.filled")
                    .resizable()
                    .frame(width: 110, height: 73)
                    .padding(.leading)
        }
    }
}

#Preview {
    T_ProfileImage()
}

