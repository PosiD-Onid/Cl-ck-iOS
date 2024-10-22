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
    let userId: String
    let hasPerformance: Bool // 수행평가 여부를 나타내는 변수 추가
    var onEdit: (UUID) -> Void
    
    @State private var isEditing = false
    @State private var newTitle: String
    @State private var newContent: String
    @State private var newGrade: String
    @State private var newClassGroup: String
    @State private var newSemester: String
    @State private var newPlace: String
    @State private var newYear: String
    
    init(id: Int, title: String, data: String, grade: Int, group: Int, semester: Int, year: Int, place: String, userId: String, hasPerformance: Bool, onEdit: @escaping (UUID) -> Void) {
        self.id = id
        self.title = title
        self.data = data
        self.grade = grade
        self.group = group
        self.semester = semester
        self.year = year
        self.place = place
        self.userId = userId
        self.hasPerformance = hasPerformance
        self.onEdit = onEdit
        
        _newTitle = State(initialValue: title)
        _newContent = State(initialValue: data)
        _newGrade = State(initialValue: "\(grade)")
        _newClassGroup = State(initialValue: "\(group)")
        _newSemester = State(initialValue: "\(semester)")
        _newPlace = State(initialValue: place)
        _newYear = State(initialValue: "\(year)")
    }
    
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let semesters = ["1", "2"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    
    var body: some View {
        VStack(spacing: 0) {
            Image(hasPerformance ? "fillFolder" : "emptyFolder")
                .resizable()
                .frame(maxWidth: 75, maxHeight: 65)
            Text(title+"_\(grade)학년\(group)반")
                .font(.system(size: 13))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 40)
                .foregroundStyle(.black)
            Button {
                isEditing = true
            }label: {
                Text("수정")
                    .foregroundStyle(.blue)
                    .font(.system(size: 10))
            }
        }
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
                                
                                Picker("반", selection: $newClassGroup) {
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
                        Service.shared.updateLesson(id: String(id),
                                                    title: newTitle,
                                                    content: newContent,
                                                    grade: newGrade,
                                                    class: newClassGroup,
                                                    semester: newSemester,
                                                    place: newPlace,
                                                    year: newYear,
                                                    teacherId: userId) { result in
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
