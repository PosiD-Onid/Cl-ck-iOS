//
//  da.swift
//  Cl!ck
//
//  Created by 이다경 on 7/25/24.
//

import SwiftUI

struct TeacherPageView: View {
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
        NavigationView {
            VStack {
                TeacherPageHeader()
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
    }
}

#Preview {
    TeacherPageView()
}
