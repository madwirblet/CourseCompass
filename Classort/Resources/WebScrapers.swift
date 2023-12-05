//
//  WebScrapers.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import Foundation

func collectCourseInfo(term: String, increment: @escaping (Int) -> Void, setThreshold: @escaping (Int) -> Void) async -> [Course] {
    //ufsnippet!.TOTALROWS
    let urlp1 = "https://one.uf.edu/apix/soc/schedule?ai=false&auf=false&category=CWSP&class-num=&course-code=&course-title=&cred-srch=&credits=&day-f=&day-m=&day-r=&day-s=&day-t=&day-w=&dept=&eep=&fitsSchedule=false&ge=&ge-b=&ge-c=&ge-d=&ge-h=&ge-m=&ge-n=&ge-p=&ge-s=&instructor=&last-control-number="
    let urlp2 = "&level-max=&level-min=&no-open-seats=false&online-a=&online-c=&online-h=&online-p=&period-b=&period-e=&prog-level=&qst-1=&qst-2=&qst-3=&quest=false&term="
    let urlp3 = "&wr-2000=&wr-4000=&wr-6000=&writing=false&var-cred=&hons=false"
    
    var num = 0
    var firstIteration = true
    var courses: [Course] = []
    
    repeat {
        if let url = URL(string: urlp1 + String(num) + urlp2 + term + urlp3) {
            do {
                let contents = try String(contentsOf: url)
                let ufsnippet = decodeUFCourseJSON(JSON: contents)
                guard (ufsnippet != nil) else {
                    break
                }
                num = ufsnippet!.LASTCONTROLNUMBER
                if firstIteration {
                    setThreshold(ufsnippet!.TOTALROWS)
                    firstIteration = false
                }
                
                if num == 0 {
                    break
                }
                
                courses.append(contentsOf: ufsnippet!.COURSES)
                
                increment(ufsnippet!.RETRIEVEDROWS)
            } catch {
                print("Catch statement reached in collectCourseInfo. Is something broken?")
            }
        } else {
            print("Else statement reached in collectCourseInfo. Is something broken?")
        }
    } while (num != 0)
    
    for i in courses.indices {
        courses[i].instructor = getCourseInstructor(course: courses[i])
        courses[i].rating = getInstructorRating(instructor: courses[i].instructor)
    }
    
    return courses
}

func getCourseInstructor(course: Course) -> String {
    if let firstSection = course.sections.first {
        var commonInstructorNames = Set(firstSection.instructors.map { $0.name })

        for section in course.sections.dropFirst() {
            let instructorNames = Set(section.instructors.map { $0.name })
            commonInstructorNames.formIntersection(instructorNames)
        }

        if let commonName = commonInstructorNames.first {
            return commonName
        } else {
            return "Variable"
        }
    } else {
        return "Variable"
    }
}
    
func getInstructorRating(instructor: String?) -> Int? {
    if let instructor = instructor {
        return ratings[instructor]
    }
    return nil
}



func collectTermInfo() async -> [Term] {
    let s = "https://one.uf.edu/apix/soc/filters"
    if let url = URL(string: s) {
        do {
            let contents = try String(contentsOf: url)
            let ufsnippet = decodeUFTermJSON(JSON: contents)
            guard let ufsnippet = ufsnippet else {
                return []
            }
            return ufsnippet.terms
        } catch {
            print("Catch statement reached in collectTermInfo. Is something broken?")
        }
    } else {
        print("Else statement reached in collectTermInfo. Is something broken?")
    }
    return []
}

func decodeUFCourseJSON(JSON: String) -> OneUFSnippet? {
    if let jsonData = JSON.data(using: .utf8) {
        do {
            let oneufs = try JSONDecoder().decode([OneUFSnippet].self, from: jsonData)
            return oneufs[0]
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    return nil
}

func decodeUFTermJSON(JSON: String) -> Program? {
    if let jsonData = JSON.data(using: .utf8) {
        do {
            let program = try JSONDecoder().decode(Program.self, from: jsonData)
            return program
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    return nil
}
