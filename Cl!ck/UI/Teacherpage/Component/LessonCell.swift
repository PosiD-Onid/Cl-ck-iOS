//
//  LessonCell.swift
//  Cl!ck
//
//  Created by 이다경 on 9/11/24.
//

import Foundation
import SwiftUI

struct LessonCell: View {
    var lesson: Lesson? // Lesson을 매개변수로 받도록 수정
    
    var body: some View {
        VStack {
            if let lesson = lesson {
                Text("선택한 수업: \(lesson.l_title)")
                    .font(.title)
                    .padding()
                
                Text("수업 내용: \(lesson.l_content)")
                    .font(.body)
                    .padding()
                
                Text("학년: \(lesson.l_grade), 반: \(lesson.l_class)")
                    .font(.body)
                    .padding()
                
                // 추가적인 수행평가 보기 내용
            } else {
                Text("수업 정보 없음")
                    .font(.title)
                    .padding()
            }
        }
    }
}

#Preview {
    LessonCell()
}
