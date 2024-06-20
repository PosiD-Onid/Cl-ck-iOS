import SwiftUI

struct Login: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var password = ""
    @State private var showpassword = false
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: "arrow.backward")
                    .font(.title2)
                    .bold()
                Text("로그인")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    Login()
}
