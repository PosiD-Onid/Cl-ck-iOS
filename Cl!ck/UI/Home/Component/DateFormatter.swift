//
//  DateFormatter.swift
//  Cl!ck
//
//  Created by 이다경 on 8/1/24.
//

import Foundation

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
