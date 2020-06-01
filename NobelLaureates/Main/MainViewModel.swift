//
//  MainViewModel.swift
//  NobelLaureates
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewModel: NSObject {
    
    let apiService: ApiServiceProtocol
    fileprivate var laureates: [Laureate] = [Laureate]()
    
    var longitudeInput: Double?
    var latitudeInput: Double?
    var yearInput: Int?
    
    var numberOfCells: Int {
        return laureateCellVMs.count
    }
    
    fileprivate var laureateCellVMs = [LaureateCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            showErrorMessageClosure?()
        }
    }
    
    var invalidInputClosure: (()->())?
    var reloadTableViewClosure: (()->())?
    var showErrorMessageClosure: (()->())?
    
    init(_ api: ApiServiceProtocol = ApiService()) {
        self.apiService = api
    }
    
    func fetch(){
        apiService.fetchNobelPrizeData { (successful, result, error) in
            if let err = error{
                //display error alert
                self.errorMessage = "\(err)"
            }else{
                
                //sort array to display Laureates in ascending order
                self.sort(unsortedArray: result) { (sortedArray) in
                    
                    //process data
                    self.process(sortedArray: sortedArray)
                }
            }
        }
    }
    
    fileprivate func sort(unsortedArray: [Laureate], completion: @escaping([Laureate])->()){
        completion(mergeSort(unsortedArray))
    }
    
    //O(n log n)
    fileprivate func mergeSort(_ array: [Laureate]) -> [Laureate] {
      guard array.count > 1 else { return array }

      let middleIndex = array.count / 2
      
      let leftArray = mergeSort(Array(array[0..<middleIndex]))
      let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
      
      return merge(leftArray, rightArray)
    }

    fileprivate func merge(_ left: [Laureate], _ right: [Laureate]) -> [Laureate] {
      var leftIndex = 0
      var rightIndex = 0

      var orderedArray: [Laureate] = []
      
      while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]

        if getJumps(laureate: leftElement) < getJumps(laureate: rightElement) {
          orderedArray.append(leftElement)
          leftIndex += 1
        } else if getJumps(laureate: leftElement) > getJumps(laureate: rightElement) {
          orderedArray.append(rightElement)
          rightIndex += 1
        } else {
          orderedArray.append(leftElement)
          leftIndex += 1
          orderedArray.append(rightElement)
          rightIndex += 1
        }
      }

      while leftIndex < left.count {
        orderedArray.append(left[leftIndex])
        leftIndex += 1
      }

      while rightIndex < right.count {
        orderedArray.append(right[rightIndex])
        rightIndex += 1
      }
      
      return orderedArray
    }
    
    func getJumps(laureate: Laureate) -> Double{
        guard let inputYear = yearInput, let inputLatitude = latitudeInput, let inputLongitude = longitudeInput, let year = Double(laureate.year) else {return 0}
        let yearDifference = abs(Double(inputYear) - year)
        let distanceInKM = getDistance(lat1: inputLatitude, lng1: inputLongitude, lat2: laureate.location.lat, lng2: laureate.location.lng)
        
        //1 jump == 1year == 10km
        //jumps = difference in year + distance in km / 10
        return yearDifference + (distanceInKM/10)
    }
    
    fileprivate func getDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double{
        let firstCoordinate = CLLocation(latitude: lat1, longitude: lng1)
        let secondCoordinate = CLLocation(latitude: lat2, longitude: lng2)
        //return in Km
        return firstCoordinate.distance(from: secondCoordinate) / 1000
    }
    
    fileprivate func process(sortedArray: [Laureate]){
        self.laureates = sortedArray
        var laureateVms = [LaureateCellViewModel]()
        
        for laureate in sortedArray {
            laureateVms.append(LaureateCellViewModel(laureate))
        }
        
        self.laureateCellVMs = laureateVms
    }
    
    func getViewModel(indexPath: IndexPath) -> LaureateCellViewModel{
        return laureateCellVMs[indexPath.row]
    }
    
    func getSortedArray() -> [Laureate]{
        return laureates
    }
}

