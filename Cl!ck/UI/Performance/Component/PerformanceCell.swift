import SwiftUI
import Alamofire

struct PerformanceCell: View {
    let id: Int
    let title: String
    let place: String
    let content: String
    let startDate: Date
    let endDate: Date
    var onEdit: (Int) -> Void

    @State private var isEditing = false
    @State private var newTitle: String
    @State private var newPlace: String
    @State private var newContent: String
    @State private var startdate: Date
    @State private var enddate: Date
    @State private var selectedStartPeriod: String
    @State private var selectedEndPeriod: String

    let lessonId: Int
    let performanceId: Int

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    init(id: Int, title: String, place: String, content: String, startDate: Date, endDate: Date, lesson: Lesson?, onEdit: @escaping (Int) -> Void) {
        self.id = id
        self.title = title
        self.place = place
        self.content = content
        self.onEdit = onEdit
        
        self.performanceId = id
        self.newTitle = title
        self.newPlace = place
        self.newContent = content
        
        guard let lessonId = lesson?.id else {
            fatalError("수업 ID를 가져올 수 없습니다.")
        }
        self.lessonId = lessonId
        
        self.startDate = startDate
        self.endDate = endDate
        
        self.startdate = startDate
        self.enddate = endDate
        
        self.selectedStartPeriod = ""
        self.selectedEndPeriod = ""
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("수행평가: \(title)")
                    .font(.system(size: 18, weight: .semibold))
                Rectangle()
                    .frame(height: 0.8)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                Text("장소: \(place)")
                    .font(.system(size: 13))
                Text("기간: \(formattedDateAndTime(from: startDate))")
                    .font(.system(size: 13))
                Text("- \(formattedDateAndTime(from: endDate))")
                    .font(.system(size: 13))
                Text("내용: \(content)")
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
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.background)
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
                                ForEach(availableEndPeriods(), id: \.self) { period in
                                    Text(period)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }

                        Section(header: Text("수행평가 정보")) {
                            TextEditor(text: $newContent)
                                .frame(minHeight: 100)
                        }
                    }
                    
                    Button("저장") {
                        let (newStartDate, newEndDate) = formatISODate(from: startdate, startPeriod: selectedStartPeriod, endPeriod: selectedEndPeriod)

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
                        Button("취소") {
                            isEditing = false
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("수행평가 수정하기")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    private func formattedDateAndTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE HH시 mm분"
        return dateFormatter.string(from: date)
    }

    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE HH시 mm분" // 시간대 제외
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어로 설정
        return dateFormatter.string(from: date)
    }
    
    private func formatISODate(from date: Date, startPeriod: String, endPeriod: String) -> (String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let calendar = Calendar.current
        
        let startTime = getStartTime(for: startPeriod)
        let startComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let finalStartDate = calendar.date(bySettingHour: calendar.component(.hour, from: startTime),
                                            minute: calendar.component(.minute, from: startTime),
                                            second: 0,
                                            of: calendar.date(from: startComponents)!)
        
        let endTime = getEndTime(for: endPeriod)
        let finalEndDate = calendar.date(bySettingHour: calendar.component(.hour, from: endTime),
                                          minute: calendar.component(.minute, from: endTime),
                                          second: 0,
                                          of: calendar.date(from: startComponents)!)
        
        return (formatter.string(from: finalStartDate!), formatter.string(from: finalEndDate!))
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
            return createDate(from: "13:30")
        case "6교시":
            return createDate(from: "14:30")
        case "7교시":
            return createDate(from: "15:30")
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
            return createDate(from: "12:40")
        case "5교시":
            return createDate(from: "14:20")
        case "6교시":
            return createDate(from: "15:20")
        case "7교시":
            return createDate(from: "16:20")
        default:
            return Date()
        }
    }
    
    private func createDate(from time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: time) ?? Date()
    }

    private func availableEndPeriods() -> [String] {
        return ["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"]
    }
    
    private func determinePeriod(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 8:
            return "1교시"
        case 9:
            return "2교시"
        case 10:
            return "3교시"
        case 11:
            return "4교시"
        case 13:
            return "5교시"
        case 14:
            return "6교시"
        case 15:
            return "7교시"
        default:
            return "미정"
        }
    }
}
