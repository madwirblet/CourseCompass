//
//  MergeSort.swift
//  Classort
//
//  Created by Harper Fuchs on 12/1/23.
//


func merge<T>(list: inout [T], comparator: (T, T) -> Bool, left: Int, mid: Int, right: Int) {
    let numElements1: Int = mid - left + 1 // number of elements in the first subarray
    let numElements2: Int = right - mid // number of elements in the second subarray
    
    let first = Array(list[left..<left + numElements1])
    let second = Array(list[mid + 1..<mid + 1 + numElements2])

    var index1: Int = 0
    var index2: Int = 0
    var newIndex: Int = left
    
    var newArray = [T]() // newly sorted array

    while index1 < numElements1 && index2 < numElements2 {
        if comparator(second[index2], first[index1]) {
            newArray.append(first[index1])
            index1 += 1
        }
        else {
            newArray.append(second[index2])
            index2 += 1
        }

        newIndex += 1
    }

    while index1 < numElements1 {
        newArray.append(first[index1])
        index1 += 1
        newIndex += 1
    }

    while index2 < numElements2 {
        newArray.append(second[index2])
        index2 += 1
        newIndex += 1
    }

    list.replaceSubrange(left...right, with: newArray)
}

func mergeSort<T>(list: inout [T], comparator: (T, T) -> Bool, left: Int, right: Int, courseIndex: Int) {
    if left < right {
        let mid: Int = left + (right - left) / 2
        mergeSort(list: &list, comparator: comparator, left: left, right: mid, courseIndex: courseIndex)
        mergeSort(list: &list, comparator: comparator, left: mid + 1, right: right, courseIndex: courseIndex)
        merge(list: &list, comparator: comparator, left: left, mid: mid, right: right)
    }
}
