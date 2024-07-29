//
//  InformationDetailView.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct InformationDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let Title: String
    let DetailDate: Date
    let Location: String
    let DetailTime: Date
    let Content: String
    let CircleColor: SwiftUI.Color
    
    private var formattedDate: String {
        // 날짜를 한국어로 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")  // 한국어 로케일
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: DetailDate)
    }
    
    private var formattedTime: String {
        // 시간을 한국어로 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")  // 한국어 로케일
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: DetailTime)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                    
                }
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
            }
            .padding(.top, 30)
            .padding(.bottom, 100)
            .background(Color.red)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InformationDetailView(Title: "국어수행", DetailDate: Date(), Location: "국어실", DetailTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date()) ?? Date(), Content: "수행평가내용", CircleColor: Color.green)
}
