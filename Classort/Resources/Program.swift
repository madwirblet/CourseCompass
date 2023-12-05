//
//  Program.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import Foundation

struct Program: Codable {
    let categories: [Category]
    let progLevels: [ProgramLevel]
    let terms: [Term]
    let departments: [Department]
}

struct Category: Codable {
    let CODE: String
    let DESC: String
}

struct ProgramLevel: Codable {
    let CODE: String
    let DESC: String
}

struct Term: Codable {
    let CODE: String
    let DESC: String
    let SORT_TERM: Int
}

struct Department: Codable {
    let CODE: StringCast
    let DESC: String
}
