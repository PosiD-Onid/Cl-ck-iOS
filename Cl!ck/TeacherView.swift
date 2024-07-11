//
//  TPage.swift
//  Click01
//
//  Created by 이다경 on 4/10/24.
//

import SwiftUI


struct TeacherPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack(spacing: 100) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 15.87, height: 15.87)
                        }
                        Image("ClickLogo")
                            .resizable()
                            .frame(width: 100, height: 45)
                        NavigationLink(destination: MainCalendarView()) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 21.5, height: 15.5)
                        }
                    }
                    
                    .foregroundColor(.accentColor)
                }
                TeacherList()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    TeacherPage()
}

