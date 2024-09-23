import SwiftUI
import Alamofire

struct PerformanceCell: View {
    let id: Int
    let title: String
    let place: String
    let content: String
    let startDate: String
    let endDate: String
    var onEdit: (Int) -> Void
    
    @State private var isEditing = false
    @State private var newTitle: String
    @State private var newPlace: String
    @State private var newContent: String
    @State private var startdate: Date
    @State private var enddate: Date
    @State private var selectedStartPeriod = "1교시"
    @State private var selectedEndPeriod = "1교시"
    
    let lessonId: Int
    let performanceId: Int
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    init(id: Int, title: String, place: String, content: String, startDate: String, endDate: String, lesson: Lesson?, onEdit: @escaping (Int) -> Void) {
        self.id = id
        self.title = title
        self.place = place
        self.content = content
        self.startDate = startDate
        self.endDate = endDate
        self.onEdit = onEdit
        
        self.performanceId = id
        self.newTitle = title
        self.newPlace = place
        self.newContent = content
        
        guard let lessonId = lesson?.id else {
            fatalError("수업 ID를 가져올 수 없습니다.")
        }
        self.lessonId = lessonId
        
        self.startdate = dateFormatter.date(from: startDate) ?? Date()
        self.enddate = dateFormatter.date(from: endDate) ?? Date()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("새 수행평가: \(title)")
                    .font(.system(size: 18, weight: .semibold))
                Rectangle()
                    .frame(height: 0.8)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                HStack {
                    Text("장소: \(place)")
                        .font(.system(size: 13))
                    Spacer()
                    Text("교시: \(selectedStartPeriod) ~ \(selectedEndPeriod)")
                        .font(.system(size: 13))
                    Spacer()
                }
                Text("기간: \(formattedDate(from: startDate)) - \(formattedDate(from: endDate))")
                    .font(.system(size: 13))
            }
            Spacer()
            VStack {
                Button(action: {
                    isEditing.toggle()
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
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.8)
                .padding(.horizontal)
        )
        .sheet(isPresented: $isEditing) {
            NavigationView {
                VStack {
                    Form {
                        Section {
                            TextField("수행평가 제목", text: $newTitle)
                            Picker("장소", selection: $newPlace) {
                                ForEach(["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Section(header: Text("시작 날짜 및 시간 설정")) {
                            DatePicker("시작 날짜", selection: $startdate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                            Picker("시작 교시", selection: $selectedStartPeriod) {
                                ForEach(["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Section(header: Text("종료 날짜 및 시간 설정")) {
                            DatePicker("종료 날짜", selection: $enddate, in: startdate..., displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                            Picker("종료 교시", selection: $selectedEndPeriod) {
                                ForEach(["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        Section(header: Text("수행평가 정보")) {
                            TextEditor(text: $newContent)
                                .frame(minHeight: 100)
                        }
                    }
                    
                    Button("Save") {
                        let newStartDate = formatISODate(from: startdate, period: selectedStartPeriod)
                        let newEndDate = formatISODate(from: enddate, period: selectedEndPeriod)
                        
                        Service.shared.updatePerformance(id: String(performanceId),
                                                         title: newTitle,
                                                         place: newPlace,
                                                         content: newContent,
                                                         startDate: newStartDate,
                                                         endDate: newEndDate,
                                                         lessonId: String(lessonId)) { result in
                            switch result {
                            case .success(let message):
                                print("수행평가 업데이트 성공: \(message)")
                                isEditing = false
                            case .failure(let error):
                                print("수행평가 업데이트 실패: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    .padding()
                }
                .foregroundColor(.black)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("수행평가 수정하기")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    private func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func getStartTime(for period: String) -> Date {
        switch period {
        case "1교시":
            return createDate(from: "08:50")
        case "2교시":
            return createDate(from: "09:50")
        case "3교시":
            return createDate(from: "10:50")
        case "4교시":
            return createDate(from: "11:50")
        case "5교시":
            return createDate(from: "12:40")
        case "6교시":
            return createDate(from: "13:40")
        case "7교시":
            return createDate(from: "14:40")
        default:
            return Date()
        }
    }
    
    private func getEndTime(for period: String) -> Date {
        switch period {
        case "1교시":
            return createDate(from: "09:40")
        case "2교시":
            return createDate(from: "10:40")
        case "3교시":
            return createDate(from: "11:40")
        case "4교시":
            return createDate(from: "12:30")
        case "5교시":
            return createDate(from: "13:30")
        case "6교시":
            return createDate(from: "14:30")
        case "7교시":
            return createDate(from: "15:30")
        default:
            return Date()
        }
    }
    
    private func createDate(from timeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let time = dateFormatter.date(from: timeString) else { return Date() }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: startdate)
        let finalDate = calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                      minute: calendar.component(.minute, from: time),
                                      second: 0,
                                      of: calendar.date(from: components)!)
        return finalDate!
    }
    
    private func formatISODate(from date: Date, period: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 시간 설정
        let time = getStartTime(for: period)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let finalDate = calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                      minute: calendar.component(.minute, from: time),
                                      second: 0,
                                      of: calendar.date(from: components)!)
        
        return formatter.string(from: finalDate!)
    }
    
}


#Preview {
    LessonListView()
}
