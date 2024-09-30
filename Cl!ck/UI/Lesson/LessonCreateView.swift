import SwiftUI
import Alamofire

struct LessonCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSubmitting = false
    @State private var submissionMessage: String? = nil
    @State private var showAlert = false
    @State private var navigateToTeacherTabView = false
    
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
    
    @State private var selectTab = 1
    
//    var teacherId: String = "qwe" // 실제 사용자 ID로 교체 필요
    var userId: String

    var body: some View {
        NavigationView {
            VStack {
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
                
                Button(action: createLesson) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("확인")
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
                
                NavigationLink(
                    destination: TeacherTabView(selectedTab: $selectTab, userId: userId),
                    isActive: $navigateToTeacherTabView,
                    label: { EmptyView() }
                )

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
                            Text("수업 생성하기")
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
            teacherId: userId
        ) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    clearFields()
                    navigateToTeacherTabView = true // TeacherTabView로 이동
                case .failure(let error):
                    submissionMessage = "오류 발생: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }

    private func clearFields() {
        title = ""
        content = ""
        selectedGrade = "1"
        selectedClass = "1"
        selectedSemester = "1"
        selectedPlace = "교실"
        year = ""
    }

    private var isTextFieldFilled: Bool {
        !title.isEmpty && !content.isEmpty && !selectedGrade.isEmpty && !selectedClass.isEmpty && !selectedSemester.isEmpty && !selectedPlace.isEmpty && !year.isEmpty
    }
}
//
//#Preview {
//    LessonCreateView()
//}
