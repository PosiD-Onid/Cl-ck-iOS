import SwiftUI

struct ScheduleListView: View {
    @State private var showInformationDetailView = false
    var selectedDate: Date?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }

    private var formattedDate: String {
        guard let date = selectedDate else { return "" }
        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack {
            Divider()
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            VStack {
                HStack {
                    Text("\(formattedDate)")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showInformationDetailView = true
                        }
                    }) {
                        ScheduleCell(
                            Title: "국어수행",
                            Location: "국어실",
                            DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(),
                            CircleColor: Color.green
                        )
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: 365)
        }
        .overlay(
            Group {
                if showInformationDetailView {
                    InformationDetailView(
                        Title: "국어수행",
                        DetailDate: Date(),
                        Location: "국어실",
                        DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(),
                        Content: "수행평가내용",
                        CircleColor: Color.green,
                        dismissAction: {
                            withAnimation(.easeInOut) {
                                showInformationDetailView = false
                            }
                        }
                    )
                    .background(Color.white) // 배경색 추가
                    .transition(.move(edge: .trailing))
                    .zIndex(0) // zIndex를 높여 최상위로 표시
                }
            }
        )
    }
}


#Preview {
    ScheduleListView(selectedDate: Date())
}
