import SwiftUI

struct TeacherSignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name = ""
    @State private var subject = ""
    @State private var username = ""
    @State private var password = ""
    @State private var checkpassword = ""
    @State private var checkPassword = false
    @State private var showPassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    @State private var passwordsMatch = true
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case subject
        case username
        case password
        case checkPassword
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("C!ick 선생님 회원가입 페이지 입니다")
                        .font(.system(size: 23))
                    
                    TextField("이름", text: $name)
                        .autocapitalization(.none)
                        .padding(.all)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: name) { _ in
                            checkTextFields()
                        }
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .subject
                        }
                    
                    TextField("담당 과목명", text: $subject)
                        .autocapitalization(.none)
                        .padding(.all)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: subject) { _ in
                            checkTextFields()
                        }
                        .focused($focusedField, equals: .subject)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .username
                        }
                    
                    TextField("아이디", text: $username)
                        .autocapitalization(.none)
                        .padding(.all)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: username) { _ in
                            checkTextFields()
                        }
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    HStack {
                        Group {
                            if showPassword {
                                TextField("비밀번호", text: $password)
                            } else {
                                SecureField("비밀번호", text: $password)
                            }
                        }
                        .autocapitalization(.none)
                        .textContentType(.newPassword)
                        .frame(minHeight: 22.2)
                        
                        Button(action: {
                            self.showPassword.toggle()
                        }, label: {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        })
                    }
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: password) { _ in
                        checkPasswordMatch()
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .checkPassword
                    }
                    
                    HStack {
                        Group {
                            if checkPassword {
                                TextField("비밀번호 확인", text: $checkpassword)
                            } else {
                                SecureField("비밀번호 확인", text: $checkpassword)
                            }
                        }
                        .autocapitalization(.none)
                        .textContentType(.newPassword)
                        .frame(minHeight: 22.5)
                        
                        Button(action: {
                            self.checkPassword.toggle()
                        }, label: {
                            Image(systemName: checkPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        })
                    }
                    .focused($focusedField, equals: .checkPassword)
                    .submitLabel(.done)
                    .padding(.all)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: checkpassword) { _ in
                        checkPasswordMatch()
                    }
                    
                    if !passwordsMatch {
                        Text("비밀번호가 일치하지 않습니다.")
                            .foregroundColor(.red)
                            .font(.system(size: 13))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: OnBoardingView()) {
                    Text("확인")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isTextFieldFilled && isPasswordFilled && passwordsMatch ? Color("MainColor") : Color("MainColor").opacity(0.5))
                        .cornerRadius(6)
                }
                .padding(.horizontal, 29)
                .disabled(!isTextFieldFilled || !isPasswordFilled || !passwordsMatch)
                
                NavigationLink(destination: EntireSignInView()) {
                    Text("이미 회원가입을 진행하셨나요?")
                        .font(.system(size: 13))
                        .underline()
                }
                .padding(.bottom)
            }
            .padding(.top)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 27)
                                .foregroundColor(.black)
                            Text("회원가입")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
    
    private func checkTextFields() {
        isTextFieldFilled = !name.isEmpty && !subject.isEmpty && !username.isEmpty
    }
    
    private func checkPasswordMatch() {
        isPasswordFilled = !password.isEmpty && !checkpassword.isEmpty
        passwordsMatch = password == checkpassword
    }
}

#Preview {
    TeacherSignUpView()
}
