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
            HStack {
                Text("그렇지 않나여 ㅎ")
                    .font(.title)
                Image(systemName: "person")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
