//
//  ButtonView.swift
//  Cl!ck
//
//  Created by Junha on 6/20/24.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            NavigationLink(destination: TeacherPage()) {
                HStack {
                    Spacer()
                    ZStack{
                        Circle()
                            .frame(width: 70)
                            .foregroundColor(.gray)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 10)
                    .padding()
                    Spacer()
                }
            }
        }
    }
}
