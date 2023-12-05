//
//  QuickSort.swift
//  Classort
//
//  Created by Maddy Wirbel on 12/1/23.
//

func partitionHelper<T>(list: inout [T], comparator: (T, T) -> Bool, low: Int, high: Int) -> Int {
    let pivot: T = list[low]
    
    var down: Int = high
    var up: Int = low
    
    while up < down{
        for _ in up..<high {
            if comparator(list[up], pivot) {
                break
            }
            up += 1
        }
        
        for _ in (low..<high).reversed() {
            if comparator(pivot, list[down])  {
                break
            }
            down -= 1
        }
        
        if up < down{
            let temp: T = list[up]
            list[up] = list[down]
            list[down] = temp
        }
    }
    
    let temp: T = list[low]
    list[low] = list[down]
    list[down] = temp
    
    return down
    
}

func quickSort<T>(list: inout [T], comparator: (T, T) -> Bool, low: Int, high: Int){
    if low < high{
        let pivot: Int = partitionHelper(list: &list, comparator: comparator, low: low, high: high)
        quickSort(list: &list, comparator: comparator, low: low, high: pivot - 1)
        quickSort(list: &list, comparator: comparator, low: pivot + 1, high: high)
    }
}
