import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @Binding var showSheet: Bool
    var onSuccess: () -> Void
    
    @State private var nowPassword: String = ""
    @State private var changePassword: String = ""
    @State private var checkPassword: String = ""
    
    @State private var nowShowPassword = false
    @State private var changeShowPassword = false
    @State private var checkShowPassword = false
    
    @State private var isnowpassFieldFilled = false
    @State private var ischangepassFieldFilled = false
    @State private var ischeckpassFieldFilled = false
    
    @FocusState private var focusedField: Field?
    @State private var isEditing = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum Field {
        case nowPassword
        case changePassword
        case checkPassword
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                HStack {
                    Group {
                        if nowShowPassword {
                            TextField("현재 비밀번호", text: $nowPassword)
                                .focused($focusedField, equals: .nowPassword)
                                .submitLabel(.done)
                        } else {
                            SecureField("현재 비밀번호", text: $nowPassword)
                                .focused($focusedField, equals: .nowPassword)
                                .submitLabel(.done)
                        }
                    }
                    .autocapitalization(.none)
                    .frame(minHeight: 22.2)
                    
                    Button(action: {
                        self.nowShowPassword.toggle()
                    }, label: {
                        Image(systemName: nowShowPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    })
                }
                .padding(.all)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: nowPassword) { newValue in
                    isnowpassFieldFilled = !newValue.isEmpty
                }
                
                HStack {
                    Group {
                        if changeShowPassword {
                            TextField("변경할 비밀번호", text: $changePassword)
                                .focused($focusedField, equals: .changePassword)
                                .submitLabel(.done)
                        } else {
                            SecureField("변경할 비밀번호", text: $changePassword)
                                .focused($focusedField, equals: .changePassword)
                                .submitLabel(.done)
                        }
                    }
                    .autocapitalization(.none)
                    .frame(minHeight: 22.2)
                    
                    Button(action: {
                        self.changeShowPassword.toggle()
                    }, label: {
                        Image(systemName: changeShowPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    })
                }
                .padding(.all)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: nowPassword) { newValue in
                    ischangepassFieldFilled = !newValue.isEmpty
                }
                
                HStack {
                    Group {
                        if checkShowPassword {
                            TextField("비밀번호 확인", text: $checkPassword)
                                .focused($focusedField, equals: .checkPassword)
                                .submitLabel(.done)
                        } else {
                            SecureField("비밀번호 확인", text: $checkPassword)
                                .focused($focusedField, equals: .checkPassword)
                                .submitLabel(.done)
                        }
                    }
                    .autocapitalization(.none)
                    .frame(minHeight: 22.2)
                    
                    Button(action: {
                        self.checkShowPassword.toggle()
                    }, label: {
                        Image(systemName: checkShowPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    })
                }
                .padding(.all)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: nowPassword) { newValue in
                    ischeckpassFieldFilled = !newValue.isEmpty
                }
                .padding(.bottom)
                
                Button(action: {
                    if changePassword.isEmpty || nowPassword.isEmpty || checkPassword.isEmpty {
                        alertMessage = "빈칸 없이 입력해주세요."
                        showAlert = true
                        return
                    }
                    
                    if changePassword != checkPassword {
                        alertMessage = "변경할 비밀번호와 비밀번호 확인이 일치하지 않습니다."
                        showAlert = true
                        return
                    }
                    
                    Service.shared.passwordchange(
                        currentPassword: nowPassword,
                        newPassword: changePassword
                    ) { result in
                        switch result {
                        case .success(let response):
                            alertMessage = response
                            showAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showSheet = false
                            }
                            onSuccess()
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }) {
                    HStack {
                        Text("변경")
                    }
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.main)
                    .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
