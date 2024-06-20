import SwiftUI

struct STSignup: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var showPassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    @State private var passwordsMatch = true // 비밀번호 일치 여부
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HeadView
                    .padding([.top, .leading])
                VStack {
                    BodyView
                    ButtonView
                        .disabled(!isTextFieldFilled || !isPasswordFilled)
                    Spacer()
                        .frame(height: 0)
                    NavigationLink(destination: STLogin()) {
                        Text("이미 회원가입을 진행했나요?")
                            .underline()
                            .font(.system(size: 13))
                    }

                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                // 키보드가 나타날 때 버튼을 숨깁니다.
                self.showPassword = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                // 키보드가 사라질 때 버튼을 다시 표시합니다.
                self.showPassword = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var HeadView: some View {
        HStack {
            Button(action: { dismiss() }, label: {
                HStack {
                    Image(systemName: "chevron.backward")
                        .font(.title)
                    Text("회원가입")
                        .fontWeight(.heavy)
                        .font(.system(size: 25))
                }
            })
            .foregroundColor(.black)
        }
    }
    
    private var BodyView: some View {
        VStack(alignment: .leading) {
            Text("C!ick 회원가입 페이지 입니다")
                .font(.title2)
            TextField("이름", text: $name)
                .autocapitalization(.none)
                .padding(.leading)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6 )
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: username) { newValue in
                    isTextFieldFilled = !newValue.isEmpty
                }
            TextField("아이디", text: $username)
                .autocapitalization(.none)
                .padding(.leading)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6 )
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: username) { newValue in
                    isTextFieldFilled = !newValue.isEmpty
                }
                .padding(.vertical).frame(height: 60)
            
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
            .padding(.top).frame(height: 43)
            
            if !passwordsMatch {
                Text("비밀번호가 일치하지 않습니다.")
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding(.top, 50)
    }
    
    private var ButtonView: some View {
        NavigationLink(destination: MainView()) {
            Text("확인")
                .frame(width: 350, height: 50)
                .foregroundColor(.white)
                .background(isTextFieldFilled && isPasswordFilled && passwordsMatch ? Color("MainColor") : Color("MainColor").opacity(0.5))
                .cornerRadius(6)
        }
        .padding()
    }
    
    private func checkPasswordMatch() {
        isPasswordFilled = !password.isEmpty && !checkPassword.isEmpty
        passwordsMatch = password == checkPassword
    }
}

#Preview {
    STSignup()
}
