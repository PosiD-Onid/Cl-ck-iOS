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
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Circle()
                            .frame(maxWidth: 24)
                            .foregroundColor(Color.main.opacity(0.7))
                            .padding(.trailing, 14)
                        Text(title)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    HStack {
                        Image(systemName: "location")
                            .resizable()
                            .frame(maxWidth: 23, maxHeight: 23)
                            .padding(.trailing, 15)
                        Text(place)
                            .font(.system(size: 23))
                    }
                    HStack {
                        VStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(maxWidth: 23, maxHeight: 21)
                                .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.trailing, 15)
                        VStack {
                            Text(formattedstartDate)
                                .padding(.bottom, 2)
                            Text(formattedendDate)
                        }
                        .font(.system(size: 23))
                    }
                    HStack {
                        Image(systemName: "text.alignleft")
                            .resizable()
                            .frame(maxWidth: 23, maxHeight: 23)
                            .padding(.trailing, 15)
                        Text(content)
                            .font(.system(size: 23))
                    }
                }
                .padding(.leading, 25)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView()
}
