import SwiftUI

struct TSignup: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name = ""
    @State private var subject = ""
    @State private var username = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var showPassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    @State private var passwordsMatch = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("C!ick 회원가입 페이지 입니다")
                    .font(.system(size: 23))
                TextField("이름", text: $name)
                    .autocapitalization(.none)
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6 )
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: username) { newValue in
                        isTextFieldFilled = !newValue.isEmpty
                    }
                TextField("담당 과목명", text: $subject)
                    .autocapitalization(.none)
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6 )
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: username) { newValue in
                        isTextFieldFilled = !newValue.isEmpty
                    }
                TextField("아이디", text: $username)
                    .autocapitalization(.none)
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6 )
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: username) { newValue in
                        isTextFieldFilled = !newValue.isEmpty
                    }
                
                HStack {
                    if showPassword {
                        SecureField("비밀번호", text: $password)
                            .autocapitalization(.none)
                    } else {
                        TextField("비밀번호", text: $password)
                            .autocapitalization(.none)
                    }
                    Button(action: {
                        self.showPassword.toggle()
                    }, label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .padding(.trailing)
                            .foregroundColor(.gray)
                    })
                }
                .padding(.leading)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6 )
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: password) { newValue in
                    isPasswordFilled = !newValue.isEmpty
                    checkPasswordMatch()
                }
                .padding(.vertical).frame(height: 60)
                
                HStack {
                    if showPassword {
                        SecureField("비밀번호 확인", text: $checkPassword)
                            .autocapitalization(.none)
                    } else {
                        TextField("비밀번호 확인", text: $checkPassword)
                            .autocapitalization(.none)
                    }
                    Button(action: {
                        self.showPassword.toggle()
                    }, label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .padding(.trailing)
                            .foregroundColor(.gray)
                    })
                }
                .padding(.leading)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6 )
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: checkPassword) { newValue in
                    checkPasswordMatch()
                }
                
                if !passwordsMatch {
                    Text("비밀번호가 일치하지 않습니다.")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                
                Spacer()
                NavigationLink(destination: MainView()) {
                    Text("확인")
                        .frame(width: 350, height: 50)
                        .foregroundColor(.white)
                        .background(isTextFieldFilled && isPasswordFilled && passwordsMatch ? Color("MainColor") : Color("MainColor").opacity(0.5))
                        .cornerRadius(6)
                }
            }

        }
    }
    
    private func checkPasswordMatch() {
        isPasswordFilled = !password.isEmpty && !checkPassword.isEmpty
        passwordsMatch = password == checkPassword
    }
}

#Preview {
    TSignup()
}
