import SwiftUI

struct aaaa: View {
    @State private var showMenu = false

    var body: some View {
        ZStack {
            // Main content view
            VStack {
                Text("Main Content")
                    .font(.largeTitle)
                    .padding()

                Button(action: {
                    showMenu.toggle()
                }) {
                    Text("Toggle Menu")
                        .font(.title)
                        .padding()
                }
            }
            .blur(radius: showMenu ? 5 : 0) // Blur the background when menu is shown

            // Bottom Sheet Menu
            if showMenu {
                BottomSheetMenu(showMenu: $showMenu)
                    .transition(.move(edge: .bottom))
                    .animation(.default)
            }
        }
    }
}

struct BottomSheetMenu: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Menu Content")
                    .font(.title)
                    .padding()

                Button(action: {
                    showMenu.toggle()
                }) {
                    Text("Close Menu")
                        .font(.title2)
                        .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
        }
        .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}
#Preview {
    aaaa()
}
