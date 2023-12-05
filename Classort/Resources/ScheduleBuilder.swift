//
//  ScheduleBuilder.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class ScheduleBuilder {
    let courseCombinations: [[Course]]
    let blocked: [Int]
    let lowBound: Int
    let highBound: Int
    
    init(courses: [Course], priority: [Course], blocked: [Int], lowBound: Int, highBound: Int) {
        var secondary = Array(courses)
        
        for course in priority {
            if let index = secondary.firstIndex(where: { $0 == course }) {
                secondary.remove(at: index)
            }
        }
        
        var combinations = secondary.combinations
        
        for i in combinations.indices {
            combinations[i].append(contentsOf: priority)
        }
        
        self.courseCombinations = combinations
        self.lowBound = lowBound
        self.highBound = highBound
        self.blocked = blocked
    }
    
    func buildSchedules() -> [Schedule] {
        var schedules: [Schedule] = []
        for i in courseCombinations.indices {
            buildSectionCombinations(combIdx: i, courseIdx: 0, prev: Schedule(), result: { schedule in
                schedules.append(schedule)
            })
        }
        return schedules
    }
    
    func buildSectionCombinations(combIdx: Int, courseIdx: Int, prev: Schedule?, result: @escaping (Schedule) -> Void) {
        guard let prev = prev else {
            return
        }
        
        if courseIdx >= courseCombinations[combIdx].count {
            if prev.creditsMax >= lowBound {
                result(prev)
            }
            return
        }
        
        let code = courseCombinations[combIdx][courseIdx].code
        for section in courseCombinations[combIdx][courseIdx].sections {
            buildSectionCombinations(combIdx: combIdx, courseIdx: courseIdx + 1, prev: prev.with(cls: code, section: section, bound: highBound, blocked: blocked), result: result)
        }
    }
}

extension Array {
    var combinations: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinations.flatMap { [$0, [self[0]] + $0] }
    }
}
