import SwiftUI

struct PerformanceListView: View {
    let id: UUID
    let title: String
    let data: String
    let grade: Int
    let group: Int
    var onEdit: (UUID) -> Void
    var onDelete: (UUID) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.bottom)
                Text("\(grade)학년 \(group)반")
                    .font(.system(size: 13))
            }
            Spacer()
            Button(action: {
                onEdit(id) // 수정 요청을 전달
            }) {
                Image(systemName: "ellipsis")
                    .frame(width: 13, height: 13)
            }
            .padding(.bottom, 35)
        }
        .foregroundColor(.black)
        .padding(.vertical, 23)
        .padding(.horizontal, 35)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.buttongary)
                .padding(.horizontal)
            )
//        .contextMenu {
//            Button(action: {
//                onEdit(id) // 수정 요청을 전달
//            }) {
//                Label("수정", systemImage: "pencil")
//            }
//            Button(action: {
//                onDelete(id) // 삭제 요청을 전달
//            }) {
//                Label("삭제", systemImage: "trash")
//                    .foregroundColor(.red)
//            }
//        }
    }
}

#Preview {
    LessonListView()
}
