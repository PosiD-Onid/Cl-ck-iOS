import SwiftUI

struct LessonListCell: View {
    let id: UUID // 고유 식별자
    let title: String
    let data: String
    let grade: Int
    let group: Int
    var onEdit: (UUID) -> Void // 수정 요청을 전달할 클로저
    var onDelete: (UUID) -> Void // 삭제 요청을 전달할 클로저

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                Text(data)
                    .font(.system(size: 15))
            }
            Spacer()
            Text("\(grade)학년 \(group)반")
                .font(.system(size: 15))
                .padding(.bottom)
        }
        .padding(.vertical, 23)
        .padding(.horizontal, 35)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .padding(.horizontal)
        )
        .contextMenu {
            NavigationLink(destination: TeacherPageView(schedule: Schedule(id: id, title: title, data: data, grade: grade, group: group))) {
                            Button(action: {
                                onEdit(id) // 수정 요청을 전달
                            }) {
                                Label("수정", systemImage: "pencil")
                            }
                        }
            Button(action: {
                onDelete(id) // 삭제 요청을 전달
            }) {
                Label("삭제", systemImage: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    LessonListView()
}
