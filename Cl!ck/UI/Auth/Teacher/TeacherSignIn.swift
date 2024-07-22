import SwiftUI

struct TeacherSignIn: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var username = ""
    @State private var password = ""
    @State private var showpassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("C!ick계정으로 로그인 해주세요")
                        .font(.system(size: 23))
                    TextField("아이디", text: $username)
                        .autocapitalization(.none)
                        .padding(.all)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6 )
                                .stroke(.gray400, lineWidth: 1)
                        )
                        .onChange(of: username) { newValue in
                            isTextFieldFilled = !newValue.isEmpty
                        }
                    
                    HStack {
                        Group {
                            if showpassword {
                                TextField("비밀번호", text: $password)
                            } else {
                                SecureField("비밀번호",text: $password)
                            }
                        }
                        .autocapitalization(.none)
                        .frame(minHeight: 22.2)
                        Button(action: {
                            self.showpassword.toggle()
                        }, label: {
                            Image(systemName: showpassword ? "eye" : "eye.slash")
                                .padding(.trailing)
                                .foregroundColor(.gray400)
                        })
                    }
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6 )
                            .stroke(.gray400, lineWidth: 1)
                    )
                    .onChange(of: password) { newValue in
                        isPasswordFilled = !newValue.isEmpty
                    }
                }
                .padding(.top, 45)
                .padding(.horizontal)
                Spacer()
                NavigationLink(destination: MainView()) {
                    Text("확인")
                        .font(.system(size: 20))
                    //                        .frame(width: 350, height: 50)
                        .padding(.horizontal, 170)
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .background(isTextFieldFilled && isPasswordFilled ? Color("MainColor") : Color("MainColor").opacity(0.5))
                        .cornerRadius(6)
                }
                .disabled(!isTextFieldFilled || !isPasswordFilled)
                NavigationLink(destination: TSignup()) {
                    Text("C!ick에 처음오신 선생님이신가요?")
                        .font(.system(size: 13))
                        .underline()
                }
                .padding(.bottom)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            self.showpassword = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.showpassword = true
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15,height: 27)
                            .foregroundColor(.black)
                        Text("로그인")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.leading)
                    }
                }
            }
        }
    }
    
    
}


#Preview {
    TeacherSignIn()
}
