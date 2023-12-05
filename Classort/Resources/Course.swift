//
//  OneUFSnippet.swift
//  Classort
//
//  Created by Devin Wylde on 11/29/23.
//

import Foundation
import SwiftyJSON

struct OneUFSnippet: Codable {
    let COURSES: [Course]
    let LASTCONTROLNUMBER: Int
    let RETRIEVEDROWS: Int
    let TOTALROWS: Int
}

struct Course: Codable {
    // from dictionary
    let code: String
    let courseId: String
    let name: String
    let openSeats: IntFilter
    let termInd: String
    let description: String
    let prerequisites: String
    let sections: [Section]
    
    // custom values
    var instructor: String?
    var rating: String?
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.name == rhs.name && lhs.code == rhs.code
    }
}

struct Section: Codable {
    let number: StringCast
    let classNumber: Int
    let gradBasis: String
    let acadCareer: String
    let display: String
    let credits: IntFilter
    let credits_min: IntFilter
    let credits_max: IntFilter
    let note: StringCast
    let dNote: String
    let genEd: [String]
    let quest: [String]
    let sectWeb: String
    let rotateTitle: String
    let deptCode: IntFilter
    let deptName: String
    let openSeats: IntFilter
    let courseFee: Double
    let lateFlag: String
    let EEP: String
    let LMS: String
    let instructors: [Instructor]
    let meetTimes: [MeetTime]
    let addEligible: String
    let grWriting: String
    let finalExam: String
    let dropaddDeadline: String
    let pastDeadline: Bool
    let startDate: String
    let endDate: String
    let waitList: WaitList
}

struct Instructor: Codable {
    let name: String
}

struct MeetTime: Codable {
    let meetNo: Int
    let meetDays: [String]
    let meetTimeBegin: String
    let meetTimeEnd: String
    let meetPeriodBegin: String
    let meetPeriodEnd: String
    let meetBuilding: String
    let meetBldgCode: StringCast
    let meetRoom: StringCast
}

struct WaitList: Codable {
    let isEligible: String
    let cap: Int
    let total: Int
}

var instructorRatings: [String: String] = [:]

func collectCourseInfo(term: Int, increment: @escaping (Int) -> Void, setThreshold: @escaping (Int) -> Void) async -> [Course] {
    var num = 0
    //ufsnippet!.TOTALROWS
    //let urlp1 = "https://one.uf.edu/apix/soc/schedule?ai=false&auf=false&category=CWSP&class-num=&course-code=&course-title=&cred-srch=&credits=&day-f=&day-m=&day-r=&day-s=&day-t=&day-w=&dept=&eep=&fitsSchedule=false&ge=&ge-b=&ge-c=&ge-d=&ge-h=&ge-m=&ge-n=&ge-p=&ge-s=&instructor=&last-control-number="
    let urlp1 = "https://one.uf.edu/apix/soc/schedule?ai=false&auf=false&category=CWSP&class-num=&course-code=&course-title=&cred-srch=&credits=&day-f=&day-m=&day-r=&day-s=&day-t=&day-w=&dept=19140000&eep=&fitsSchedule=false&ge=&ge-b=&ge-c=&ge-d=&ge-h=&ge-m=&ge-n=&ge-p=&ge-s=&instructor=&last-control-number="
    let urlp2 = "&level-max=&level-min=&no-open-seats=false&online-a=&online-c=&online-h=&online-p=&period-b=&period-e=&prog-level=&qst-1=&qst-2=&qst-3=&quest=false&term="
    let urlp3 = "&wr-2000=&wr-4000=&wr-6000=&writing=false&var-cred=&hons=false"
    var courses: [Course] = []
    var firstIteration = true
    repeat {
        if let url = URL(string: urlp1 + String(num) + urlp2 + String(term) + urlp3) {
            do {
                let contents = try String(contentsOf: url)
                let ufsnippet = decodeUFJSON(JSON: contents)
                guard (ufsnippet != nil) else {
                    break
                }
                num = ufsnippet!.LASTCONTROLNUMBER
                courses.append(contentsOf: ufsnippet!.COURSES)
                if firstIteration {
                    setThreshold(ufsnippet!.TOTALROWS)
                    firstIteration = false
                }
                increment(ufsnippet!.RETRIEVEDROWS)
            } catch {
                print("Catch statement reached in collectCourseInfo. Is something broken?")
                // contents could not be loaded
            }
        } else {
            print("Else statement reached in collectCourseInfo. Is something broken?")
            // the URL was bad!
        }
    } while (num != 0)
    
    return courses
}

func fetchInstructorRatings(courseInfo: [Course], increment: @escaping () -> Void) async -> [Course] {
    var courseInfo = courseInfo
    
    for i in courseInfo.indices {
        let instructor = courseInfo[i].instructor!
        courseInfo[i].rating = "N/A"
        
        if instructor == "Variable" {
            increment()
            continue
        } else if let rating = instructorRatings[instructor] {
            courseInfo[i].rating = rating
        } else if let url = URL(string: "https://www.ratemyprofessors.com/search/professors/1100?q=" + instructor.replacingOccurrences(of: " ", with: "%20")) {
            do {
                let contents = try String(contentsOf: url)

                let regex = try NSRegularExpression(pattern: "\"avgRating\":(\\d+)", options: [])
                let matches = regex.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count))
                

                if let match = matches.first {
                    let range = match.range(at: 1)
                    if let swiftRange = Range(range, in: contents) {
                        let avgRatingString = String(contents[swiftRange])
                        courseInfo[i].rating = avgRatingString
                        instructorRatings[instructor] = avgRatingString
                    }
                }
            } catch {
                print("Catch statement reached in fetchInstructorRating. Is something broken?")
                // contents could not be loaded
            }
        } else {
            print("Else statement reached in fetchInstructorRating. Is something broken?")
            // the URL was bad!
        }
        increment()
    }
    
    return courseInfo
}

func decodeUFJSON(JSON: String) -> OneUFSnippet? {
    if let jsonData = JSON.data(using: .utf8) {
        do {
            // Decode JSON data to an array of Course objects
            let oneufs = try JSONDecoder().decode([OneUFSnippet].self, from: jsonData)
            return oneufs[0]
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    return nil
}
