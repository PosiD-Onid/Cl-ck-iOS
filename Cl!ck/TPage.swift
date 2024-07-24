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
                        .foregroundColor(Color("MainColor"))
                }
                Image("ClickLogo")
                    .resizable()
                    .frame(width: 100, height: 45)
                NavigationLink(destination: MainCalendarView()) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 21.5, height: 15.5)
                        .foregroundColor(Color("MainColor"))
                }
            }
            
            .foregroundColor(.accentColor)
        }
    }
}


struct TPageList: View {
    @Environment(\.presentationMode) var presentationMode
    
    let grades = ["1", "2", "3"]
    let classes = ["1", "2", "3", "4"]
    let subjects = ["국어", "수학", "사회", "과학", "한국사", "영어", "웹프로그래밍", "자바", "도덕", "음악"]
    let places = ["교실", "국어실", "수학실", "음악실", "과학실", "임베디드실", "체육관"]
    
    @State private var constant = false
    
    @State private var startDate: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endDate: Date = Date()
    @State private var endTime: Date = Date()
    
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
                        Toggle(isOn: $constant, label: {
                            Text("하루 종일")
                        })
                        .toggleStyle(SwitchToggleStyle(tint: Color("MainColor")))
                    if !constant {
                        DatePicker("시작", selection: $startDate)
                            .frame(height: 35)
                    } else {
                        DatePicker("시작", selection: $startDate, displayedComponents: .date)
                    }
                    if !constant {
                        DatePicker("종료", selection: $endDate)
                            .frame(height: 35)
                    } else {
                        DatePicker("종료", selection: $endDate, displayedComponents: .date)
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

