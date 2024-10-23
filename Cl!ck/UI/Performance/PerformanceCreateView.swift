import SwiftUI
import Alamofire

struct PerformanceCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var lesson: Lesson?
    
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    let periods = ["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"]
    
    @State private var isEditing = false
    @State private var startDate = Date()
    @State private var selectedPlace = "교실"
    @State private var selectedStartPeriod = "1교시"
    @State private var selectedEndPeriod = "1교시"
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var showAlert = false
    @State private var submissionMessage: String? = nil

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
                    Button {
                        createPerformance()
                    } label: {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 21.5, height: 15.5)
                            .foregroundColor(Color("MainColor"))
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("오류"), message: Text(submissionMessage ?? "알 수 없는 오류 발생"), dismissButton: .default(Text("확인")))
                    }
                }
                Form {
                    Section {
                        TextField("수행평가 제목", text: $title)
                        Picker("장소", selection: $selectedPlace) {
                            ForEach(places, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Section(header: Text("시간 설정")) {
                        DatePicker("날짜", selection: $startDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                        
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
                    
                    Section(header: Text("수행평가 내용")) {
                        TextEditor(text: $detail)
                            .frame(minHeight: 100)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var filteredEndPeriods: [String] {
        if let startIndex = periods.firstIndex(of: selectedStartPeriod) {
            return Array(periods[startIndex...])
        }
        return periods
    }
    
    private func createPerformance() {
        guard !title.isEmpty, !detail.isEmpty else {
            submissionMessage = "모든 필드를 입력해주세요."
            showAlert = true
            return
        }
        
        let (newStartDate, newEndDate) = formatISODate(from: startDate, startPeriod: selectedStartPeriod, endPeriod: selectedEndPeriod)
        
        guard let lessonId = lesson?.id else {
            submissionMessage = "수업 ID를 가져올 수 없습니다."
            showAlert = true
            return
        }
        
        Service.shared.createPerformance(
            title: title,
            place: selectedPlace,
            content: detail,
            startDate: newStartDate,
            endDate: newEndDate,
            lessonId: lessonId
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("응답:", response)
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    submissionMessage = "오류 발생: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time) ?? Date()
    }
}
