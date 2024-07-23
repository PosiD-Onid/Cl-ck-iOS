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
    
    @State var alarmtitle = [
        "웹프 수행평가 제출 3시간전",
        "국어 수행평가 하루전",
        "ㅋㅋㄹㅃㅃ",
    ]
    
    @State var alarmContents = [
        "웹프 수행평가 제출이 오후 11시 59분에 마감됩니다.",
        "국어 수행평가가 8월 19일에 있습니다.",
        "ㅋㅋㄹㅃㅃ 내용입니다.",
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarmtitle.indices, id: \.self) { index in
                    AlarmCell(title: alarmtitle[index], content: alarmContents[index])
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
        alarmtitle.remove(atOffsets: offsets)
        alarmContents.remove(atOffsets: offsets)
    }
}

#Preview {
    AlarmView()
}
