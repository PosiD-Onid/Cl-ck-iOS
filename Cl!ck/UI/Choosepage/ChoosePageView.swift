import SwiftUI

struct ChoosePageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @State private var Teacher = false
    @State private var Student = false
    
    var body: some View {
        NavigationStack {
                VStack {
                    Spacer()
                    ChooseRoleView(Teacher: $Teacher, Student: $Student)
                    Spacer()
                        .frame(maxHeight: 140)
                    NavigationLink(
                        destination: {
                            if Student {
                                return AnyView(StudentSignUpView())
                            } else if Teacher {
                                return AnyView(TeacherSignUpView())
                            } else {
                                return AnyView(EmptyView())
                            }
                        }(),
                        label: {
                            Text(Student ? "학생으로 회원가입" : (Teacher ? "선생님으로 회원가입" : "회원가입"))
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background((Teacher || Student) ? Color("MainColor") : Color("MainColor").opacity(0.5))
                                .cornerRadius(10)
                                .padding(.horizontal, 31)
                        }
                    )
                    .disabled(!(Teacher || Student))
                    .padding(.bottom)
            }
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
                            Text("사용자 유형 선택")
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

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    ChoosePageView()
}
