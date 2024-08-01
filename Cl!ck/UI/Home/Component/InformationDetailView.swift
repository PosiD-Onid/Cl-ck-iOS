import SwiftUI

struct InformationDetailView: View {
    let Title: String
    let DetailDate: Date
    let Location: String
    let DetailTime: Date
    let Content: String
    let CircleColor: SwiftUI.Color
    let dismissAction: () -> Void

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        return formatter.string(from: DetailDate)
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeStyle = .short
        return formatter.string(from: DetailTime)
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 20)
            
            HStack {
                VStack(spacing: 16) {
                    Circle()
                        .frame(maxWidth: 25)
                        .foregroundColor(CircleColor)
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(maxWidth: 23, maxHeight: 20)
                    Image(systemName: "location")
                        .resizable()
                        .frame(maxWidth: 23, maxHeight: 23)
                    Image(systemName: "bell")
                        .resizable()
                        .frame(maxWidth: 23, maxHeight: 23)
                    Image(systemName: "text.alignleft")
                        .resizable()
                        .frame(maxWidth: 23, maxHeight: 23)
                }
                .padding(.horizontal, 30)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(Title)
                        .font(.system(size: 23, weight: .semibold))
                    Text(formattedDate)
                        .font(.system(size: 23))
                    Text(Location)
                        .font(.system(size: 23))
                    Text(formattedTime)
                        .font(.system(size: 23))
                    Text(Content)
                        .font(.system(size: 23))
                }
                Spacer()
            }
            .padding(.bottom, 120)
        }
        .background(Color.white) // 배경색 추가
    }
}
