import SwiftUI

class ScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = [
        Schedule(id: UUID(), title: "내가 읽은 책 소개하기 1회차", data: "2024년 11월 15일 7교시", grade: 1, group: 3),
        // 여기에 더 많은 데이터 추가
    ]
    
    func deleteSchedule(id: UUID) {
        if let index = schedules.firstIndex(where: { $0.id == id }) {
            schedules.remove(at: index)
        }
    }
}

struct Schedule: Identifiable {
    let id: UUID
    let title: String
    let data: String
    let grade: Int
    let group: Int
}

struct WrittenScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedSchedule: Schedule? // 수정할 항목을 저장
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.schedules) { schedule in
                    WrittenScheduleCell(id: schedule.id,
                                        title: schedule.title,
                                        data: schedule.data,
                                        grade: schedule.grade,
                                        group: schedule.group,
                                        onEdit: { id in
                        if let selected = viewModel.schedules.first(where: { $0.id == id }) {
                            selectedSchedule = selected
                        }
                    },
                                        onDelete: { id in
                        viewModel.deleteSchedule(id: id)
                    })
                }
                .padding(.top)
            }
            .background(Color.background)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("작성 일정")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TeacherPageView()) {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(item: $selectedSchedule) { schedule in
                TeacherPageView(schedule: schedule)
            }
        }
    }
}

#Preview {
    WrittenScheduleView()
}
