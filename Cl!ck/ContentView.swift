//
//  ContentView.swift
//  Click01
//
//  Created by 이다경 on 4/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationControllerWrapper(viewController: UIHostingController(rootView: ContentScreenContent()))
    }
}

struct ContentScreenContent: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SecondView()) {
                    Text("Go to Second View")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the second screen")
                    .padding()
                NavigationLink(destination: ThirdView()) {
                    Text("Go to Third View")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ThirdView: View {
    var body: some View {
        NavigationStack {
            Text("This is the third screen")
                .padding()
            NavigationLink(destination: ContentView()) {
                Text("ContentView")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
