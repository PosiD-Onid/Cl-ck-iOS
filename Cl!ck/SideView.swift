//
//  SideMenu.swift
//  Cl!ck
//
//  Created by Junha on 6/20/24.
//

import SwiftUI
// MARK: - SideMenu
struct SideMenu: View {
    @Binding var onClick: Bool
    @Binding var isTapSideMenu: Bool
    
    public var body: some View {
        VStack {
            Divider()
            if onClick {
                Detailedschedule(onClick: $onClick)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 3)
                    .foregroundColor(Color.gray400)
                    .padding()
                TodayData()
                scheduleView2(onClick: $onClick)
            }
            Spacer()
            HStack {
                ButtonView()
                    .frame(width:100, height:100)
                    .padding(.leading, 270)
            }
        }
        .background(.white)
        .onTapGesture {
            withAnimation {
                isTapSideMenu.toggle()
            }
        }
        
    }
}
