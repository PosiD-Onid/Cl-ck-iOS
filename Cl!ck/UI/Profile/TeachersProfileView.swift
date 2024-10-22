import SwiftUI
import Alamofire

struct TeachersProfileView: View {
    @State private var showAlert = false
    @State private var navigateToOnboarding = false
    @State private var showChangePasswordSheet = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let username: String
    let userId: String
    let subject: String
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.background)
                            .frame(width: .infinity)
                            .frame(maxHeight: 260)
                    }
                    .padding(.top, 80)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            T_ProfileImage()
                            Spacer()
                        }
                        .padding(.bottom, 35)
                        
                        HStack {
                            Text(username)
                                .font(.system(size: 30, weight: .heavy))
                            Text("/ " + userId)
                                .font(.system(size: 18))
                        }
                        Text(subject)
                            .font(.system(size: 20, weight: .regular))
                    }
                    .padding(.horizontal, 35)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    showChangePasswordSheet = true
                }) {
                    Text("비밀번호 변경")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color.background)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showChangePasswordSheet) {
                    ChangePasswordView(showSheet: $showChangePasswordSheet) {
                        print("비밀번호가 성공적으로 변경되었습니다.")
                    }
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.5)])
                }
                
                Button(action: {
                    logout()
                }) {
                    Text("로그아웃")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color.background)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: OnBoardingView(), isActive: $navigateToOnboarding) {
                    EmptyView()
                }
                Spacer()
            }
            .background(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("프로필")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func logout() {
        AuthService.shared.signout { result in
            switch result {
            case .success(let message):
                print(message)
                self.navigateToOnboarding = true
            case .requestErr(let message):
                print("Request Error: \(message)")
                self.showAlert = true
            case .pathErr:
                print("Path Error")
                self.showAlert = true
            case .networkFail:
                print("Network Failure")
                self.showAlert = true
            case .serverErr:
                print("Server Error")
                self.showAlert = true
            }
        }
    }
}

#Preview {
    TeachersProfileView(username: "이다경", userId: "dd", subject: "국어국문학")
}
