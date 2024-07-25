//
//  TeacherPageHeader.swift
//  Cl!ck
//
//  Created by 이다경 on 7/24/24.
//

import SwiftUI

struct TeacherPageHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack(spacing: 100) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15.87, height: 15.87)
                        .foregroundColor(Color("MainColor"))
                }
                Image("ClickLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 45)
                NavigationLink(destination: MainCalendarView()) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 21.5, height: 15.5)
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
    }
}

#Preview {
    TeacherPageHeader()
}
