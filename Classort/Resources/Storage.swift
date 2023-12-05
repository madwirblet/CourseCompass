//
//  Storage.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import Foundation

func getFileURL(name: String) -> URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return directory.appendingPathComponent(name + ".json")
}

func saveCourses(term: String, courses: [Course]) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(courses)
        try data.write(to: getFileURL(name: term))
    } catch {
        print("Error saving courses: " + error.localizedDescription)
    }
}

func checkIfTermInStorage(term: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: getFileURL(name: term).path) || FileManager.default.fileExists(atPath: Bundle.main.path(forResource: term, ofType: "json") ?? "na")
}

func loadCourses(term: String) -> [Course]? {
    let fileManager = FileManager.default
    let urls = [getFileURL(name: term), URL(fileURLWithPath: Bundle.main.path(forResource: term, ofType: "json") ?? "na")]
    for url in urls {
        if fileManager.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let courses = try decoder.decode([Course].self, from: data)
                return courses
            } catch {
                print("Error loading courses: " + error.localizedDescription)
                return nil
            }
        }
    }
    
    print("Error loading courses: not found!")
    return nil
}

var ratings: [String: Int] = [:]

func loadRatings() {
    let fileManager = FileManager.default
    let path = Bundle.main.path(forResource: "ratings", ofType: "json") ?? "na"
    guard fileManager.fileExists(atPath: path) else {
        print("Error loading ratings: not found!")
        return
    }
    
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        ratings = try decoder.decode([String: Int].self, from: data)
    } catch {
        print("Error loading ratings: " + error.localizedDescription)
    }
}

var savedSchedules: [Schedule] = []

func saveSchedules() {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(savedSchedules)
        try data.write(to: getFileURL(name: "schedules"))
    } catch {
        print("Error saving schedules: " + error.localizedDescription)
    }
}

func loadSchedules() {
    let fileManager = FileManager.default
    let url = getFileURL(name: "schedules")
    guard fileManager.fileExists(atPath: url.path) else {
        return
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        savedSchedules = try decoder.decode([Schedule].self, from: data)
    } catch {
        print("Error loading schedules: " + error.localizedDescription)
    }
}

var blockedTimes: [[Bool]] = []

func saveBlockedTimes() {
    let defaults = UserDefaults.standard
    
    var btFlat: [Bool] = []
    for t in blockedTimes {
        btFlat.append(contentsOf: t)
    }
    
    defaults.set(btFlat, forKey: "blockedTimes")
}

func loadBlockedTimes() {
    let defaults = UserDefaults.standard
    
    if let btFlat = defaults.object(forKey: "blockedTimes") as? [Bool] {
        blockedTimes = btFlat.chunked(into: 5)
    } else {
        blockedTimes = [[Bool]](repeating: [Bool](repeating: false, count: 5), count: 14)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

var minCredits: Int = 12
var maxCredits: Int = 18

func saveCreditRange() {
    let defaults = UserDefaults.standard
    defaults.set(minCredits, forKey: "minCredits")
    defaults.set(maxCredits, forKey: "maxCredits")
}

func loadCreditRange() {
    let defaults = UserDefaults.standard
    
    if let min = defaults.object(forKey: "minCredits") as? Int, let max = defaults.object(forKey: "maxCredits") as? Int {
        minCredits = min
        maxCredits = max
    }
}

var quickDefault: Bool = true

func saveDefaultSort() {
    let defaults = UserDefaults.standard
    defaults.set(quickDefault, forKey: "defaultSort")
}

func loadDefaultSort() {
    let defaults = UserDefaults.standard
    
    if let ds = defaults.object(forKey: "defaultSort") as? Bool {
        quickDefault = ds
    }
}

