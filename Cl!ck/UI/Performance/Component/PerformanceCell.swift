//import SwiftUI
//import Alamofire
//
//struct PerformanceCell: View {
//    let id: Int
//    let title: String
//    let place: String
//    let content: String
//    let startDate: String
//    let endDate: String
//    let lessonId: Int // 수정된 변수 이름
//    var onEdit: (UUID) -> Void
//    
//    @State private var isEditing = false
//    @State private var performanceId: Int
//    @State private var newTitle: String
//    @State private var newPlace: String
//    @State private var newContent: String
//    @State private var newStartDate: String
//    @State private var newEndDate: String
//    
//    init(id: Int, title: String, place: String, content: String, startDate: String, endDate: String, lessonId: Int, onEdit: @escaping (UUID) -> Void) {
//        self.id = id
//        self.title = title
//        self.place = place
//        self.content = content
//        self.startDate = startDate
//        self.endDate = endDate
//        self.lessonId = lessonId
//        self.onEdit = onEdit
//        
//        _performanceId = State(initialValue: id)
//        _newTitle = State(initialValue: title)
//        _newPlace = State(initialValue: place)
//        _newContent = State(initialValue: content)
//        _newStartDate = State(initialValue: startDate)
//        _newEndDate = State(initialValue: endDate)
//    }
//    
//    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
//    
//    var teacherId: String = "qwe"
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.system(size: 22, weight: .semibold))
//                    .padding(.bottom)
//                Text("장소: \(place)")
//                    .font(.system(size: 13))
//                Text("기간: \(startDate) - \(endDate)")
//                    .font(.system(size: 13))
//            }
//            Spacer()
//            Button(action: {
//                isEditing.toggle() // 편집 모드 전환
//            }) {
//                Image(systemName: "ellipsis")
//                    .frame(width: 13, height: 13)
//            }
//            .padding(.bottom, 35)
//        }
//        .foregroundColor(.black)
//        .padding(.vertical, 23)
//        .padding(.horizontal, 35)
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(.buttongary)
//                .padding(.horizontal)
//        )
//        .sheet(isPresented: $isEditing) {
//            NavigationView {
//                VStack {
//                    Form {
//                        Section {
//                            TextField("수행평가 제목", text: $newTitle)
//                            
//                            Picker("장소", selection: $newPlace) {
//                                ForEach(places, id: \.self) {
//                                    Text($0)
//                                }
//                            }
//                            .pickerStyle(MenuPickerStyle())
//                        }
//                        
//                        Section(header: Text("수행평가 정보")) {
//                            TextEditor(text: $newContent)
//                                .frame(minHeight: 100)
//                            
//                            HStack {
//                                TextField("시작일", text: $newStartDate)
//                                    .keyboardType(.numbersAndPunctuation)
//                                TextField("종료일", text: $newEndDate)
//                                    .keyboardType(.numbersAndPunctuation)
//                            }
//                        }
//                    }
//                    
//                    Button("Save") {
//                        Service.shared.updatePerformance(lessonId: String(lessonId), // 수정된 변수 이름
//                                                         id: String(performanceId),
//                                                         title: newTitle,
//                                                         place: newPlace,
//                                                         content: newContent,
//                                                         startDate: newStartDate,
//                                                         endDate: newEndDate,
//                                                         lessonId: lessonId) { result in
//                            switch result {
//                            case .success(let message):
//                                print("수행평가 업데이트 성공: \(message)")
//                                isEditing = false
//                            case .failure(let error):
//                                print("수행평가 업데이트 실패: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                    .padding()
//                }
//                .foregroundColor(.black)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text("수행평가 수정하기")
//                            .font(.system(size: 25, weight: .bold))
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    PerformanceListView()
//}
