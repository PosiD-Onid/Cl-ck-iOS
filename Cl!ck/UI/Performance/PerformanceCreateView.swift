import SwiftUI
import Alamofire

struct PerformanceCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    let periods = ["1교시", "2교시", "3교시", "4교시", "5교시", "6교시", "7교시"]
    
    @State private var constant = false
    @State private var startDate = Date()
    @State private var selectedPlace = "교실"
    @State private var selectedStartPeriod = "1교시"
    @State private var selectedEndPeriod = "1교시" // 종료 교시 선택 변수
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
                    }  label: {
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
                        Toggle(isOn: $constant) {
                            Text("한 교시만")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("MainColor")))
                        
                        DatePicker("날짜", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                        
                        Picker("시작 교시", selection: $selectedStartPeriod) {
                            ForEach(periods, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        if !constant {
                            Picker("종료 교시", selection: $selectedEndPeriod) {
                                ForEach(filteredEndPeriods, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
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
        guard !title.isEmpty, !detail.isEmpty, !selectedPlace.isEmpty else {
            submissionMessage = "모든 필드를 입력해주세요."
            showAlert = true
            return
        }
        
        let startTime = getStartTime(for: selectedStartPeriod)
        let fullStartDate = Calendar.current.date(bySettingHour: startTime.hour, minute: startTime.minute, second: 0, of: startDate)!
        
        let fullEndDate: Date
        if constant {
            fullEndDate = Calendar.current.date(bySettingHour: getEndTime(for: selectedStartPeriod).hour, minute: getEndTime(for: selectedStartPeriod).minute, second: 0, of: startDate)!
        } else {
            fullEndDate = Calendar.current.date(bySettingHour: getEndTime(for: selectedEndPeriod).hour, minute: getEndTime(for: selectedEndPeriod).minute, second: 0, of: startDate)!
        }
        
        let formattedStartDate = formatDate(fullStartDate)
        let formattedEndDate = formatDate(fullEndDate)
        
        
        Service.shared.createPerformance(
            title: title,
            place: selectedPlace,
            content: detail,
            startDate: formattedStartDate,
            endDate: formattedEndDate, // 이제 빈 문자열 대신 실제 종료 시간 전달
            lessonId: "1"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    submissionMessage = "오류 발생: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func getStartTime(for period: String) -> (hour: Int, minute: Int) {
        switch period {
        case "1교시": return (8, 50)
        case "2교시": return (9, 50)
        case "3교시": return (10, 50)
        case "4교시": return (11, 50)
        case "5교시": return (13, 30)
        case "6교시": return (14, 30)
        case "7교시": return (15, 30)
        default: return (0, 0)
        }
    }
    
    private func getEndTime(for period: String) -> (hour: Int, minute: Int) {
        switch period {
        case "1교시": return (9, 40)
        case "2교시": return (10, 40)
        case "3교시": return (11, 40)
        case "4교시": return (12, 40)
        case "5교시": return (14, 20)
        case "6교시": return (15, 20)
        case "7교시": return (16, 20)
        default: return (0, 0)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

#Preview {
    PerformanceCreateView()
}
