//
//  RandomCourseData.swift
//  Classort
//
//  Created by Devin Wylde on 12/2/23.
//

import UIKit

func generateCourseData(nodes: Int, watch: Task<Void, Never>, increment: @escaping () -> Void) async -> [Course] {
    var courses: [Course] = []
    
    for _ in 1...nodes {
        if watch.isCancelled {
            return []
        }
        courses.append(rCourse())
        increment()
    }
    
    return courses
}

func rCourse() -> Course {
    var sections: [Section] = []
    
    for _ in 0...rInt(min: 1, max: 20) {
        sections.append(rSection())
    }
    
    return Course(
        code: rString(length: 5),
        courseId: rString(length: 5),
        name: rString(length: 10),
        sections: sections,
        instructor: rString(length: 10),
        rating: rInt(min: 1, max: 5)
    )
}

func rSection() -> Section {
    
    var genEds: [String] = []
    var instructors: [Instructor] = []
    var meetTimes: [MeetTime] = []
    
    for _ in 0...rInt(min: 0, max: 2) {
        genEds.append(rString(length: 2))
    }
    
    for _ in 0...rInt(min: 0, max: 3) {
        meetTimes.append(rMeetTime())
    }
    
    for _ in 0...rInt(min: 0, max: 2) {
        instructors.append(rInstructor())
    }
    
    return Section(
        classNumber: rInt(min: 1000, max: 9999),
        credits: rIntFilter(min: 1, max: 5),
        credits_min: rIntFilter(min: 1, max: 5),
        credits_max: rIntFilter(min: 1, max: 5),
        genEd: genEds,
        quest: [rString(length: 2)],
        sectWeb: rString(length: 3),
        instructors: instructors,
        meetTimes: meetTimes
    )
}

func rMeetTime() -> MeetTime {
    
    var meetDays: [String] = []
    
    for _ in 0...rInt(min: 0, max: 2) {
        meetDays.append(rString(length: 1))
    }
    
    return MeetTime(
        meetDays: meetDays,
        meetPeriodBegin: rString(length: 2),
        meetPeriodEnd: rString(length: 2)
    )
}

func rInstructor() -> Instructor {
    return Instructor(
        name: rString(length: 20)
    )
}

func rString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return String((0..<length).map { _ in letters.randomElement()! })
}

func rInt(min: Int, max: Int) -> Int {
    return Int.random(in: min...max)
}

func rStringCast(length: Int) -> StringCast {
    let value: String = rString(length: length)
    return StringCast(value: value)
}

func rIntFilter(min: Int, max: Int) -> IntFilter {
    let value: Int = rInt(min: min, max: max)
    return IntFilter(value: value)
}
