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
    
    let title: String = "국어 수행평가 하루전"
    let content: String = "국어 수행평가가 8월 19일에 있습니다."
    
    var body: some View {
        NavigationView {
            List {
                ForEach(1..<10) { index in
                    AlarmCell(title: title, content: content)
                }
                .onDelete(perform: deleteAlarm)
            }
            .padding(.top, 10)
            .listStyle(PlainListStyle())
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
    
    func deleteAlarm(at offsets: IndexSet) {
        print("delete alarm")
    }
}

#Preview {
    AlarmView()
}
