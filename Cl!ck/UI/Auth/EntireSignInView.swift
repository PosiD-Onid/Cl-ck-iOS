import SwiftUI

struct EntireSignInView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    
    @State private var navigateToStudentTab = false
    @State private var navigateToTeacherTab = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @FocusState private var focusedField: Field?
    
    @State private var selectedTab: Int = 0
    
    enum Field {
        case username
        case password
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("C!ick계정으로 로그인 해주세요")
                        .font(.system(size: 23))
                    
                    TextField("아이디", text: $username)
                        .autocapitalization(.none)
                        .padding(.all)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: username) { newValue in
                            isTextFieldFilled = !newValue.isEmpty
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
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.done)
                            } else {
                                SecureField("비밀번호", text: $password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.done)
                            }
                        }
                        .autocapitalization(.none)
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
                    .onChange(of: password) { newValue in
                        isPasswordFilled = !newValue.isEmpty
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    UIApplication.shared.endEditing()
                    AuthService.shared.signin(username: username, password: password) { result in
                        switch result {
                        case .success(let userType):
                            if let userType = userType as? String {
                                if userType == "student" {
                                    navigateToStudentTab = true
                                } else if userType == "teacher" {
                                    navigateToTeacherTab = true
                                }
                            } else {
                                errorMessage = "유저 타입을 확인할 수 없습니다."
                                showAlert = true
                            }
                        case .requestErr(let message):
                            errorMessage = message as? String ?? "요청 에러 발생"
                            showAlert = true
                        case .pathErr:
                            errorMessage = "잘못된 경로"
                            showAlert = true
                        case .serverErr:
                            errorMessage = "서버 오류"
                            showAlert = true
                        case .networkFail:
                            errorMessage = "네트워크 실패"
                            showAlert = true
                        default:
                            break
                        }
                    }
                }) {
                    Text("확인")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isTextFieldFilled && isPasswordFilled ? Color("MainColor") : Color("MainColor").opacity(0.5))
                        .cornerRadius(6)
                }
                .padding(.horizontal, 29)
                .disabled(!isTextFieldFilled || !isPasswordFilled)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("오류"), message: Text(errorMessage), dismissButton: .default(Text("확인")))
                }
                
                NavigationLink(destination: StudentTabView(), isActive: $navigateToStudentTab) {
                    EmptyView()
                }
                NavigationLink(destination: TeacherTabView(selectedTab: $selectedTab), isActive: $navigateToTeacherTab) {
                    EmptyView()
                }

                NavigationLink(destination: ChoosePageView()) {
                    Text("회원가입을 아직 안하셨나요?")
                        .font(.system(size: 13))
                        .underline()
                }
                .padding(.bottom)
            }
            .padding(.top)
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
                            Text("로그인")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EntireSignInView()
}
