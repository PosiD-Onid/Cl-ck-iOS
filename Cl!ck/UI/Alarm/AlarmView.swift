//
//  Alarm.swift
//  C!ick
//
//  Created by 이다경 on 4/11/24.
//

import Foundation
import SwiftUI

struct AlarmView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectedIndex: Int = 30

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach((0..<selectedIndex), id: \.self) { count in
                    VStack(spacing: 0) {
                        Button(action: {
                        }) {
                            AlarmCell(title: "웹프 수행평가 제출 3시간전", content: "웹프 수행평가 제출이 오후 11시 59분에 마감됩니다.")
                        }
                        if count < selectedIndex {
                            Divider()
                                .padding(.bottom)
                        }
                    }
                }
            }
            .padding(.top, 40)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 27)
                                .foregroundColor(.black)
                            Text("알림 기록")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AlarmView()
}
