import UIKit

var str = "Hello, playground"




let k = 2

func find(max k: Int, in arr : [Int] ) -> [Int]{
    var main_arr = arr
    let f = arr.count - k
    var min = 0
    var max = arr.count - 1
    if k == arr.count{
        return arr
    }
    var loop_count = 0
    func loop(min: Int, max: Int) -> [Int]{
        let mid = Int((min + max) / 2)
        loop_count += 1

        let min_found = Array(main_arr[0..<min])

        let search = Array(main_arr[min...max])

        let max_found = Array(main_arr[(max+1)...])



        let pivot = main_arr[mid]
        let left = min_found + search.filter{$0 < pivot}
        let right = search.filter{$0 == pivot} + search.filter{$0 > pivot} + max_found


        main_arr = left + right
        if left.count == f{
            return Array(main_arr[left.count...])
        }
        else if left.count < f{
            return loop(min: left.count + 1, max: max)
            
        } else{
            return loop(min: min, max: main_arr.count - right.count)
        }
    }
    return loop(min: min, max: max)
    
}

print(find(max: 2, in: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40]))




