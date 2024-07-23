//
//  StudentSignIn.swift
//  Cl!ck
//
//  Created by 이다경 on 7/23/24.
//

import SwiftUI

struct StudentSignIn: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    
    @State private var isTextFieldFilled = false
    @State private var isPasswordFilled = false
    
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
                    
                    HStack {
                        Group {
                            if showPassword {
                                TextField("비밀번호", text: $password)
                            } else {
                                SecureField("비밀번호", text: $password)
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
                .padding(.top, 45)
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: MainView()) {
                    Text("확인")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.horizontal, 170)
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .background(isTextFieldFilled && isPasswordFilled ? Color("MainColor") : Color("MainColor").opacity(0.5))
                        .cornerRadius(6)
                }
                .disabled(!isTextFieldFilled || !isPasswordFilled)
                
                NavigationLink(destination: StudentSignUp()) {
                    Text("C!ick에 처음온 학생인가요?")
                        .font(.system(size: 13))
                        .underline()
                }
                .padding(.bottom)
            }
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
                            Text("로그인")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StudentSignIn()
}
