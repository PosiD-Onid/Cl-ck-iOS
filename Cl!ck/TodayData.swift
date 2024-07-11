//
//  TodayData.swift
//  Cl!ck
//
//  Created by Junha on 6/27/24.
//

import Foundation
import SwiftUI

struct TodayData: View {
    let currentDate = Date()
    @State private var draggedOffset = CGSize.zero
    @State private var isActive = false
    
    var body: some View {
        HStack {
            Text(getCurrentDate())
            Text(getDayOfWeek())
            Spacer()
                .frame(width: 300)
        }
        .font(.title3 .bold())
    }
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd."
        return dateFormatter.string(from: currentDate)
    }
    
    
    func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: currentDate)
    }
}
