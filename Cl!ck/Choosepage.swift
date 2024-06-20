import SwiftUI

struct Choosepage: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var Teacher = false
    @State private var Student = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HeadView
                    Spacer().frame(width: 160)
                }
                Spacer()
                    .frame(height: 160)
                VStack {
                    BodyView
                    ButtonView
                }
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
                    Text("사용자 유형 선택")
                        .fontWeight(.heavy)
                        .font(.system(size: 25))
                }
            })
            .foregroundColor(.black)
        }
    }
    
    private var BodyView: some View {
        VStack {
            Text("선생님")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Teacher ? .white : .black)
                .frame(width: 285, height: 154)
                .background(Teacher ? Color("MainColor") : Color.buttongary)
                .cornerRadius(10)
                .onTapGesture {
                    Teacher.toggle()
                    if Teacher {
                        Student = false
                    }
                }
                .padding(.bottom, 5)
            Text("학생")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Student ? .white : .black)
                .frame(width: 285, height: 154)
                .background(Student ? Color("MainColor") : Color.buttongary)
                .cornerRadius(10)
                .onTapGesture {
                    Student.toggle()
                    if Student {
                        Teacher = false
                    }
                }
            Spacer().frame(height: 160)
        }
    }
    
    
    
    private var ButtonView: some View {
        NavigationLink(
            destination: {
                if Student {
                    return AnyView(STLogin())
                } else if Teacher {
                    return AnyView(TLogin())
                } else {
                    return AnyView(EmptyView())
                }
            }(),
            label: {
                Text(Student ? "학생으로 로그인" : (Teacher ? "선생님으로 로그인" : "로그인"))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 312, height: 54)
                    .background((Teacher || Student) ? Color("MainColor") : Color("MainColor").opacity(0.5))
                    .cornerRadius(10)
            }
        )
        .disabled(!(Teacher || Student))
    }

}

#Preview {
    Choosepage()
}
