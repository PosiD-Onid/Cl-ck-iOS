import SwiftUI

struct InformationDetailView: View {
    let title: String
    let startDate: Date
    let place: String
    let endDate: Date
    let content: String
    let dismissAction: () -> Void

    private var formattedstartDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }

    private var formattedendDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: endDate)
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
                        .foregroundColor(Color.main.opacity(0.7))
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
                    Text(title)
                        .font(.system(size: 23, weight: .semibold))
                    Text(place)
                    Text(formattedstartDate)
                    Text(formattedendDate)
                    Text(content)
                }
                .font(.system(size: 23))
                Spacer()
            }
            .padding(.bottom, 120)
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView()
}
