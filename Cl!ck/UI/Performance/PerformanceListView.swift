//
//  LessonCell.swift
//  Cl!ck
//
//  Created by 이다경 on 9/11/24.
//

import Foundation
import SwiftUI

struct PerformanceListView: View {
    var lesson: Lesson? // Lesson을 매개변수로 받도록 수정
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            if let lesson = lesson {
//                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.buttongary)
                            .padding(.horizontal)
                            .frame(maxHeight: 100)
                        VStack {
//                            Spacer()
                            Text("\(lesson.l_title)")
                                .bold()
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
//                }
            }
            else {
               Text("수업 정보 없음")
                   .font(.title)
                   .padding()
           }
        }
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
                        Text("수행평가 목록")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PerformanceCreateView()) {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LessonListView()
}
