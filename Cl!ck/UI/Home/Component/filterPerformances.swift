//
//  filterPerformances.swift
//  Cl!ck
//
//  Created by 이다경 on 10/19/24.
//

import Foundation

func filterPerformances(for date: Date?, from performances: [Performance]) -> ([Performance], Int) {
    guard let selectedDate = date else { return ([], 0) }
    
    let filteredPerformances = performances.filter {
        Calendar.current.isDate($0.startDate!, inSameDayAs: selectedDate)
    }
    
    return (filteredPerformances, filteredPerformances.count)
}
