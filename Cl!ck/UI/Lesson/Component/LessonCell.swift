import SwiftUI
import Alamofire

struct LessonCell: View {
    let id: Int
    let title: String
    let data: String
    let grade: Int
    let group: Int
    let semester: Int
    let year: Int
    let place: String
    var onEdit: (UUID) -> Void
    
    @State private var isEditing = false
    @State private var lessonId: Int
    @State private var newTitle: String
    @State private var newContent: String
    @State private var newGrade: String
    @State private var newClass: String
    @State private var newSemester: String
    @State private var newPlace: String
    @State private var newYear: String
    
    init(id: Int, title: String, data: String, grade: Int, group: Int, semester: Int, year: Int, place: String, onEdit: @escaping (UUID) -> Void) {
        self.id = id
        self.title = title
        self.data = data
        self.grade = grade
        self.group = group
        self.semester = semester
        self.year = year
        self.place = place
        self.onEdit = onEdit
        
        _lessonId = State(initialValue: id)
        _newTitle = State(initialValue: title)
        _newContent = State(initialValue: data)
        _newGrade = State(initialValue: "\(grade)")
        _newClass = State(initialValue: "\(group)")
        _newSemester = State(initialValue: "\(semester)")
        _newPlace = State(initialValue: place)
        _newYear = State(initialValue: "\(year)")
    }
    
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let semesters = ["1", "2"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    
    var teacherId: String = "qwe"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.bottom)
                Text("\(grade)학년 \(group)반")
                    .font(.system(size: 13))
            }
            Spacer()
            VStack {
                Button(action: {
                    isEditing.toggle() // 편집 모드 전환
                }) {
                    Image(systemName: "ellipsis")
                        .frame(width: 13, height: 13)
                }
                Spacer()
            }
        }
        .foregroundColor(.black)
        .padding(.vertical, 23)
        .padding(.horizontal, 35)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.buttongary)
                .padding(.horizontal)
        )
        .sheet(isPresented: $isEditing) {
            NavigationView {
                VStack {
                    Form {
                        Section {
                            TextField("수업 제목", text: $newTitle)
                            
                            HStack {
                                Picker("학년", selection: $newGrade) {
                                    ForEach(grades, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Picker("반", selection: $newClass) {
                                    ForEach(classes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        
                        Section(header: Text("수업 정보")) {
                            TextField("연도", text: $newYear)
                                .keyboardType(.numberPad)
                            Picker("학기", selection: $newSemester) {
                                ForEach(semesters, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("장소", selection: $newPlace) {
                                ForEach(places, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Section(header: Text("수업 내용")) {
                            TextEditor(text: $newContent)
                                .frame(minHeight: 100)
                        }
                    }
                    
                    Button("Save") {
                        Service.shared.updateLesson(id: String(lessonId),
                                                    title: newTitle,
                                                    content: newContent,
                                                    grade: newGrade,
                                                    class: newClass,
                                                    semester: newSemester,
                                                    place: newPlace,
                                                    year: newYear,
                                                    teacherId: teacherId) { result in
                            switch result {
                            case .success(let message):
                                print("수업 업데이트 성공: \(message)")
                                isEditing = false
                            case .failure(let error):
                                print("수업 업데이트 실패: \(error.localizedDescription)")
                            }
                        }
                    }
                    .padding()
                }
                .foregroundColor(.black)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("수업 수정하기")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    LessonListView()
}
