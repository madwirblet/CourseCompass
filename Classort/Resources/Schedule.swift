//
//  Schedule.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

struct Schedule: Codable {
    let sectionNumbers: [Int]
    let classes: [String]
    let blocks: [Int: String]
    let onlineSections: [String]
    let credits: Int
    let creditsMax: Int
    let rowStart: Int
    let rowEnd: Int
    let rating: CGFloat
    
    var height: CGFloat {
        return CGFloat(rowEnd - rowStart)
    }
    
    init(sectionNumbers: [Int], classes: [String], blocks: [Int : String], onlineSections: [String], credits: Int, creditsMax: Int, rowStart: Int, rowEnd: Int, rating: CGFloat) {
        self.sectionNumbers = sectionNumbers
        self.classes = classes
        self.blocks = blocks
        self.onlineSections = onlineSections
        self.credits = credits
        self.creditsMax = creditsMax
        self.rowStart = rowStart
        self.rowEnd = rowEnd
        self.rating = rating
    }
    
    init() {
        sectionNumbers = []
        classes = []
        blocks = [:]
        onlineSections = []
        credits = 0
        creditsMax = 0
        rowStart = 14
        rowEnd = 0
        rating = 0
    }
    
    func with(cls: String, section: Section, bound: Int, blocked: [Int]) -> Schedule? {
        
        if section.sectWeb == "AD" || section.sectWeb == "PD" {
            return Schedule(
                sectionNumbers: sectionNumbers + [section.classNumber],
                classes: classes + [cls],
                blocks: blocks,
                onlineSections: onlineSections + [cls],
                credits: credits,
                creditsMax: creditsMax,
                rowStart: rowStart,
                rowEnd: rowEnd,
                rating: rating
            )
        }
        
        let credits = credits + (section.credits_min.value ?? section.credits.value!)
        let creditsMax = creditsMax + (section.credits_max.value ?? section.credits.value!)
        
        if credits >= 18 {
            return nil
        }
        
        var newTimes = blocks
        var rowStart = rowStart
        var rowEnd = rowEnd
        
        for meetTime in section.meetTimes {
            let start = periodToInt(period: meetTime.meetPeriodBegin)
            let end = periodToInt(period: meetTime.meetPeriodEnd)
            for day in meetTime.meetDays {
                let dayInt = dayToInt(day: day)
                for i in start...end {
                    if newTimes[dayInt + i * 5] != nil || blocked.contains(dayInt + i * 5) {
                        return nil
                    }
                    newTimes[dayInt + i * 5] = cls
                }
            }
            
            if start < rowStart {
                rowStart = start
            }; if end > rowEnd {
                rowEnd = end
            }
        }
        
        let rating = CGFloat(rating)
        var curRating: CGFloat = 0
        var curRatingCount: CGFloat = 0
        for instructor in section.instructors {
            if let r = getInstructorRating(instructor: instructor.name), r != 0 {
                curRating += CGFloat(r)
                curRatingCount += 1
            }
        }
        
        let newRating = curRatingCount > 0 ? rating > 0 ? ((curRating / curRatingCount) + (rating * CGFloat(classes.count))) / CGFloat(classes.count + 1) : curRating / curRatingCount : rating

        // Return a new Schedule instance with updated values
        return Schedule(
            sectionNumbers: sectionNumbers + [section.classNumber],
            classes: classes + [cls],
            blocks: newTimes,
            onlineSections: onlineSections,
            credits: credits,
            creditsMax: creditsMax,
            rowStart: rowStart,
            rowEnd: rowEnd,
            rating: newRating
        )
    }
    
    func periodToInt(period: String) -> Int {
        switch (period) {
        case "1":
            return 0
        case "2":
            return 1
        case "3":
            return 2
        case "4":
            return 3
        case "5":
            return 4
        case "6":
            return 5
        case "7":
            return 6
        case "8":
            return 7
        case "9":
            return 8
        case "10":
            return 9
        case "11":
            return 10
        case "E1":
            return 11
        case "E2":
            return 12
        case "E3":
            return 13
        default:
            return 0
        }
    }

    func dayToInt(day: String) -> Int {
        switch (day) {
        case "M":
            return 0
        case "T":
            return 1
        case "W":
            return 2
        case "R":
            return 3
        case "F":
            return 4
        default:
            return 0
        }
    }
    
    static func == (lhs: Schedule, rhs: Schedule) -> Bool {
        if lhs.blocks.count != rhs.blocks.count {
            return false
        }
        for time in lhs.blocks.keys {
            guard let val = rhs.blocks[time], val == lhs.blocks[time] else {
                return false
            }
        }
        return true
    }
}
