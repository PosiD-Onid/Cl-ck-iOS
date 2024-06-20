import SwiftUI

struct STLogin: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var password = ""
    @State private var showpassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    
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
                    NavigationLink(destination: STSignup()) {
                        Text("C!ick에 처음온 학생인가요?")
                            .underline()
                            .font(.system(size: 13))
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                // 키보드가 나타날 때 버튼을 숨깁니다.
                self.showpassword = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                // 키보드가 사라질 때 버튼을 다시 표시합니다.
                self.showpassword = true
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
                    Text("로그인")
                        .fontWeight(.heavy)
                        .font(.system(size: 25))
                }
            })
            .foregroundColor(.black)
        }
    }
    
    private var BodyView: some View {
        VStack(alignment: .leading) {
            Text("C!ick계정으로 로그인 해주세요")
                .font(.title2)
            TextField("아이디", text: $username)
                .autocapitalization(.none)
                .padding(.leading)
                .frame(width: 350, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6 )
                        .stroke(.gray400, lineWidth: 1)
                )
                .onChange(of: username) { newValue in
                    isTextFieldFilled = !newValue.isEmpty
                }
            HStack {
                if showpassword {
                    TextField("비밀번호", text: $password)
                        .autocapitalization(.none)
                } else {
                    SecureField("비밀번호",text: $password)
                        .autocapitalization(.none)
                }
                Button(action: {
                    self.showpassword.toggle()
                }, label: {
                    Image(systemName: showpassword ? "eye" : "eye.slash")
                        .padding(.trailing)
                        .foregroundColor(.gray400)
                })
            }
            .padding(.leading)
            .frame(width: 350, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 6 )
                    .stroke(.gray400, lineWidth: 1)
            )
            .onChange(of: password) { newValue in
                isPasswordFilled = !newValue.isEmpty
            }
            .padding(.top).frame(height: 45)
            Spacer()
        }
        .padding(.top, 50)
    }
    
    private var ButtonView: some View {
        NavigationLink(destination: MainView()) {
            Text("확인")
                .frame(width: 350, height: 50)
                .foregroundColor(.white)
                .background(isTextFieldFilled && isPasswordFilled ? Color("MainColor") : Color("MainColor").opacity(0.5))
                .cornerRadius(6)
        }
        .padding()
    }
}

#Preview {
    STLogin()
}
