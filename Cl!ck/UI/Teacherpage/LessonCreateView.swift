import SwiftUI
import Alamofire

struct LessonCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var grade: String = ""
    @State private var `class`: String = ""
    @State private var semester: String = ""
    @State private var place: String = ""
    @State private var year: String = ""

    @State private var isSubmitting = false
    @State private var submissionMessage: String? = nil
    @State private var showAlert = false
    
    @FocusState private var focusedField: Field?

    enum Field {
        case title
        case content
        case grade
        case `class`
        case semester
        case place
        case year
    }
    
    var teacherId: String = "teacherID" // 실제 사용자 ID로 교체 필요

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("수업 생성하기")
                    .font(.system(size: 23, weight: .bold))

                Group {
                    TextField("수업 제목", text: $title)
                        .focused($focusedField, equals: .title)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .content }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("수업 내용", text: $content)
                        .focused($focusedField, equals: .content)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .grade }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("학년", text: $grade)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .grade)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .class }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("반", text: $class)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .class)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .semester }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("학기", text: $semester)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .semester)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .place }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("수업 장소", text: $place)
                        .focused($focusedField, equals: .place)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .year }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))

                    TextField("연도", text: $year)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .year)
                        .submitLabel(.done)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.horizontal)

                Spacer()
                
                Button(action: createLesson) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("저장")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(isTextFieldFilled ? Color("MainColor") : Color("MainColor").opacity(0.5))
                            .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 29)
                .disabled(!isTextFieldFilled)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("오류"), message: Text(submissionMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
                }
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("수업 생성하기")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func createLesson() {
        guard !title.isEmpty, !content.isEmpty, !grade.isEmpty, !`class`.isEmpty, !semester.isEmpty, !place.isEmpty, !year.isEmpty else {
            submissionMessage = "모든 필드를 입력해주세요."
            showAlert = true
            return
        }

        isSubmitting = true

        Service.shared.createLesson(title: title, content: content, grade: grade, class: `class`, semester: semester, place: place, year: year, teacherId: teacherId) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success(let lesson):
                    submissionMessage = "수업 생성 완료: \(lesson.l_title)"
                    title = ""
                    content = ""
                    grade = ""
                    `class` = ""
                    semester = ""
                    place = ""
                    year = ""
                case .failure(let error):
                    submissionMessage = "오류 발생: \(error.localizedDescription)"
                }
                showAlert = true
            }
        }
    }

    private var isTextFieldFilled: Bool {
        !title.isEmpty && !content.isEmpty && !grade.isEmpty && !`class`.isEmpty && !semester.isEmpty && !place.isEmpty && !year.isEmpty
    }
}

#Preview {
    LessonCreateView()
}
