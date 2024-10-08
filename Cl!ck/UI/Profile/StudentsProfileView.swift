import SwiftUI
import Alamofire

struct StudentsProfileView: View {
    @State private var showAlert = false
    @State private var navigateToOnboarding = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let Name: String
    let Grade: Int
    let Class: Int
    let Number: Int
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .frame(maxHeight: 260)
                    }
                    .padding(.top, 100)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            ProfileImage()
                            Spacer()
                        }
                        .padding(.bottom, 35)
                        
                        Text(Name)
                            .font(.system(size: 30, weight: .heavy))
                        Text("\(Grade)학년 \(Class)반 \(Number)번")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .padding(.horizontal, 35)
                }
                .padding(.bottom, 20)
                
                // 로그아웃 버튼
                Button(action: {
                    logout()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("로그아웃")
                        Spacer()
                    }
                    .font(.system(size: 20))
                    .padding(.leading)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // 네비게이션 트리거
                NavigationLink(destination: OnBoardingView(), isActive: $navigateToOnboarding) {
                    EmptyView()
                }
                
                Spacer()
            }
            .background(Color.background)
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
    
    // 로그아웃 함수
    func logout() {
        AuthService.shared.signout { result in
            switch result {
            case .success(let message):
                print(message) // 로그아웃 성공 메시지 출력
                self.navigateToOnboarding = true // OnBoardingView로 이동
            case .requestErr(let message):
                print("Request Error: \(message)") // 서버로부터 받은 에러 메시지
                self.showAlert = true // 에러 알림 표시
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
    StudentsProfileView(Name: "이다경", Grade: 2, Class: 2, Number: 4)
}
