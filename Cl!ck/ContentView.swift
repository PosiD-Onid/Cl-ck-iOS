//
//  ContentView.swift
//  Cl!ck
//
//  Created by Junha on 3/21/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Image("LSCon")
                    .resizable()
                    .frame(width: 237.9228302472, height: 100)
                Divider()
                    .frame(width:300)
                    .background(Color.black)
                Text("오직 학생들에 의한, 학생들을 위한")
                    .padding(.top, 15)
                Text("수행평가 관리 플랫폼 C!ick")
            }
            .padding(.top, 50)
            Button(action: {
                
            }){
                HStack {
                    Image("DAuth-Icon")
                        .resizable()
                        .frame(width:24, height: 24)
                    Text("DAuth로 시작하기")
                        .foregroundStyle(Color.black)
                        .bold()
                }
                .padding()
                .frame(width: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 1)
                    )
                .padding(.top, 300)
            }
            Button(action: {
                
            }){
                Text("회원 가입을 진행할까요?")
                    .foregroundStyle(Color.black)
                    .bold()
                    .font(.system(size:13))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
