import SwiftUI

struct TeacherPageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let subjects = ["국어", "수학", "사회", "과학", "한국사", "영어", "웹프로그래밍", "자바", "도덕", "음악"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    let periods = ["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"]

    @State private var constant = false
    @State private var startDate = Date()
    @State private var selectedGrade = ""
    @State private var selectedClass = ""
    @State private var selectedPlace = ""
    @State private var selectedSubject = ""
    @State private var selectedStartPeriod = "1교시"
    @State private var selectedEndPeriod = "1교시"
    @State private var title: String = ""
    @State private var detail: String = ""
    
    var schedule: Schedule? // 수정할 항목의 데이터를 받을 변수

    // 시작 교시에 따라 필터링된 종료 교시
    var filteredEndPeriods: [String] {
        if let startIndex = periods.firstIndex(of: selectedStartPeriod) {
            return Array(periods[startIndex...])
        }
        return periods
    }
    
    // 현재 날짜
    private var currentDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }

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
                    NavigationLink(destination: WrittenScheduleView()) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 21.5, height: 15.5)
                            .foregroundColor(Color("MainColor"))
                    }
                }
                Form {
                    Section {
                        TextField("수행평가 제목", text: $title)
                            .onAppear {
                                if let schedule = schedule {
                                    title = schedule.title
                                    selectedGrade = "\(schedule.grade)"
                                    selectedClass = "\(schedule.group)"
                                    // 추가 필드 초기화
                                }
                            }
                        
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
                    
                    Section(header: Text("시간 설정")) {
                        Toggle(isOn: $constant) {
                            Text("하루 종일")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("MainColor")))
                        
                        if constant {
                            DatePicker("날짜", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .onChange(of: startDate) { newDate in
                                    if newDate < currentDate {
                                        startDate = currentDate
                                    }
                                }
                        } else {
                            DatePicker("날짜", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .onChange(of: startDate) { newDate in
                                    if newDate < currentDate {
                                        startDate = currentDate
                                    }
                                }
                            
                            Picker("시작 교시", selection: $selectedStartPeriod) {
                                ForEach(periods, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("종료 교시", selection: $selectedEndPeriod) {
                                ForEach(filteredEndPeriods, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    Section(header: Text("과목 및 장소")) {
                        Picker("과목", selection: $selectedSubject) {
                            ForEach(subjects, id: \.self) {
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
                    
                    Section(header: Text("수행평가 내용")) {
                        TextEditor(text: $detail)
                            .frame(minHeight: 100) // 텍스트 편집기의 최소 높이 설정
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TeacherPageView()
}
