//
//  dustmq.swift
//  Cl!ck
//
//  Created by 이다경 on 8/1/24.
//

import SwiftUI

struct dustmq: View {

    var body: some View {
        NavigationView {
            TabView {
                Rectangle()
                    .fill(.red)
                    .tabItem { Text("dd") }
                    .ignoresSafeArea()
                Rectangle()
                    .fill(.yellow)
                    .tabItem { Text("aa") }
                    .ignoresSafeArea()
                Rectangle()
                    .fill(.green)
                    .tabItem { Text("bb") }
                    .ignoresSafeArea()
            }
//            .frame(
//                width: UIScreen.main.bounds.width ,
//                height: UIScreen.main.bounds.height
//            )
//            .tabViewStyle(PageTabViewStyle())
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    dustmq()
}
