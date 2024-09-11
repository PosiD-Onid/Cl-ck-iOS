//
//  PageHeader.swift
//  Cl!ck
//
//  Created by 이다경 on 9/11/24.
//

import Foundation
import SwiftUI

struct PageHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack(spacing: 100) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15.87, height: 15.87)
                    .foregroundColor(Color("MainColor"))
            }
            Image("C_ickLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 45)
            NavigationLink(destination: LessonListView()) {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 21.5, height: 15.5)
                    .foregroundColor(Color("MainColor"))
            }
        }
    }
}

#Preview {
    PageHeader()
}
