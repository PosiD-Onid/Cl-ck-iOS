//
//  TPage.swift
//  Click01
//
//  Created by 이다경 on 4/10/24.
//

import SwiftUI


struct TPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TPageheadView
                CalenderView()
                    .padding(.vertical)
                TPageList()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var TPageheadView: some View {
        VStack {
            HStack(spacing: 100) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15.87, height: 15.87)
                }
                Image("ClickLogo")
                    .resizable()
                    .frame(width: 100, height: 45)
                NavigationLink(destination: MainCalendarView()) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 21.5, height: 15.5)
                }
            }
            
            .foregroundColor(Color("MainColor"))
            Divider()
        }
    }
}


struct TPageList: View {
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let subjects = ["국어", "수학", "사회", "과학", "한국사", "기술가정", "웹프로그래밍", "자바", "도덕", "음악"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    @State private var selected_grade = ""
    @State private var selected_class = ""
    @State private var selected_place = ""
    @State private var selected_subject = ""
    @State private var title: String = ""
    @State private var detail: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("수행평가 제목", text: $title)
                    HStack {
                        Picker("학년", selection: $selected_grade) {
                            ForEach(grades, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        Picker("반", selection: $selected_class) {
                            ForEach(classes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                Section {
                    Picker("과목", selection: $selected_subject) {
                        ForEach(subjects, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    Picker("장소", selection: $selected_place) {
                        ForEach(places, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section(header: Text("수행평가 내용")) {
                    TextEditor(text: $detail)
                }
            }
        }
    }
}

#Preview {
    TPage()
}
