import SwiftUI
import Alamofire

struct LessonCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSubmitting = false
    @State private var submissionMessage: String? = nil
    @State private var showAlert = false
    @State private var isLessonCreated = false // 수업 생성 상태를 관리
    
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let semesters = ["1", "2"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedGrade = "1"
    @State private var selectedClass = "1"
    @State private var selectedSemester = "1"
    @State private var selectedPlace = "교실"
    @State private var year: String = ""
    
    var teacherId: String = "qwe" // 실제 사용자 ID로 교체 필요

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 100) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15.87, height: 15.87)
                            .foregroundColor(Color("MainColor"))
                    }
                    Image("C_ickLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 45)
                    Button(action: createLesson) {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 21.5, height: 15.5)
                                .foregroundColor(Color("MainColor"))
                        }
                    }
                    .disabled(!isTextFieldFilled)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("오류"), message: Text(submissionMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
                    }
                }
                
                Form {
                    Section {
                        TextField("수업 제목", text: $title)
                        
                        HStack {
                            Picker("학년", selection: $selectedGrade) {
                                ForEach(grades, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("반", selection: $selectedClass) {
                                ForEach(classes, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    Section(header: Text("수업 정보")) {
                        TextField("연도", text: $year)
                            .keyboardType(.numberPad)
                        Picker("학기", selection: $selectedSemester) {
                            ForEach(semesters, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker("장소", selection: $selectedPlace) {
                            ForEach(places, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    
                    Section(header: Text("수업 내용")) {
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                    }
                }
                
                // NavigationLink 추가
                NavigationLink(
                    destination: LessonListView(),
                    isActive: $isLessonCreated,
                    label: { EmptyView() }
                )
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .navigationBarBackButtonHidden()
    }

    private func createLesson() {
        guard !title.isEmpty, !content.isEmpty, !selectedGrade.isEmpty, !selectedClass.isEmpty, !selectedSemester.isEmpty, !selectedPlace.isEmpty, !year.isEmpty else {
            submissionMessage = "모든 필드를 입력해주세요."
            showAlert = true
            return
        }

        isSubmitting = true

        Service.shared.createLesson(
            title: title,
            content: content,
            grade: selectedGrade,
            class: selectedClass,
            semester: selectedSemester,
            place: selectedPlace,
            year: year,
            teacherId: teacherId
        ) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success(let lesson):
                    submissionMessage = "수업 생성 완료: \(lesson.l_title)"
                    clearFields()
                    isLessonCreated = true // 수업 생성 후 navigation 트리거
                case .failure(let error):
                    submissionMessage = "오류 발생: \(error.localizedDescription)"
                }
                showAlert = true
            }
        }
    }

    private func clearFields() {
        title = ""
        content = ""
        selectedGrade = ""
        selectedClass = ""
        selectedSemester = ""
        selectedPlace = ""
        year = ""
    }

    private var isTextFieldFilled: Bool {
        !title.isEmpty && !content.isEmpty && !selectedGrade.isEmpty && !selectedClass.isEmpty && !selectedSemester.isEmpty && !selectedPlace.isEmpty && !year.isEmpty
    }
}

#Preview {
    LessonCreateView()
}
