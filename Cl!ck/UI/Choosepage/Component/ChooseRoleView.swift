import SwiftUI

struct ChooseRoleView: View {
    
    @Binding var Teacher: Bool
    @Binding var Student: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("선생님입니다")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Teacher ? .white : .black)
                .padding(.vertical, 77)
                .padding(.horizontal, 110)
                .background(Teacher ? Color("MainColor") : Color.buttongary)
                .cornerRadius(10)
                .onTapGesture {
                    Teacher.toggle()
                    if Teacher {
                        Student = false
                    }
                }
            Text("학생입니다")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Student ? .white : .black)
                .padding(.vertical, 77)
                .padding(.horizontal, 120)
                .background(Student ? Color("MainColor") : Color.buttongary)
                .cornerRadius(10)
                .onTapGesture {
                    Student.toggle()
                    if Student {
                        Teacher = false
                    }
                }
        }
    }
}

#Preview {
    @State var teacher = false
    @State var student = false
    return ChooseRoleView(Teacher: $teacher, Student: $student)
}
