//
//  SortingFuncs.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

func compareNameAsc(_ one: Course, _ two: Course) -> Bool {
    return one.name > two.name
}

func compareNameDesc(_ one: Course, _ two: Course) -> Bool {
    return one.name < two.name
}

func compareCodeAsc(_ one: Course, _ two: Course) -> Bool {
    return one.code > two.code
}

func compareCodeDesc(_ one: Course, _ two: Course) -> Bool {
    return one.code < two.code
}

func compareInstructorAsc(_ one: Course, _ two: Course) -> Bool {
    return one.instructor! > two.instructor!
}

func compareInstructorDesc(_ one: Course, _ two: Course) -> Bool {
    return one.instructor! < two.instructor!
}

func compareRatingAsc(_ one: Course, _ two: Course) -> Bool {
    if let ro = one.rating, let rt = two.rating {
        return ro < rt
    } else if one.rating != nil {
        return false
    } else if two.rating != nil {
        return true
    }
    return one.code < two.code
}

func compareRatingDesc(_ one: Course, _ two: Course) -> Bool {
    if let ro = one.rating, let rt = two.rating {
        return ro > rt
    } else if one.rating != nil {
        return true
    } else if two.rating != nil {
        return false
    }
    return one.code > two.code
}

extension CourseListViewController {
    func sortByNameAsc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareNameAsc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareNameAsc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByNameDesc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareNameDesc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareNameDesc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByCodeAsc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareCodeAsc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareCodeAsc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByCodeDesc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareCodeDesc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareCodeDesc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByInstructorAsc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareInstructorAsc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareInstructorAsc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByInstructorDesc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareInstructorDesc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareInstructorDesc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByRatingAsc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareRatingAsc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareRatingAsc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func sortByRatingDesc() {
        if quickDefault {
            quickSort(list: &courseInfo, comparator: compareRatingDesc(_:_:), low: 0, high: courseInfo.count - 1)
        } else {
            mergeSort(list: &courseInfo, comparator: compareRatingDesc(_:_:), left: 0, right: courseInfo.count - 1, courseIndex: -1)
        }
    }

    func reverseSort() {
        courseInfo.reverse()
    }
}
