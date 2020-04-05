//
//  BoundingBox.swift
//  Integration Threaded
//
//  Created by Jeff Terry on 4/4/20.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Cocoa

class BoundingBox: NSObject {
    
    var numberOfDimensions :Int = 0
    var lowerRange:[Double]  = []
    var upperRange:[Double] = []
    var volume = 1.0
    
    /// initWithDimensionsAndRanges
    /// - Parameters:
    ///   - dimensions: number of Dimensions of the box
    ///   - lowerBound: array of lower limits in space of the box, count should be equal to or greater than the dimensions
    ///   - upperBound: array of upper limits in space of the box, count should be equal to or greater than the dimensions
    func initWithDimensionsAndRanges(dimensions: Int, lowerBound: [Double], upperBound: [Double]){
        
        upperRange.removeAll()
        lowerRange.removeAll()
        
        numberOfDimensions = dimensions
        lowerRange += lowerBound
        upperRange += upperBound
        
        volume = calculateVolume(lower: lowerRange, upper: upperRange, dimensions: numberOfDimensions)
        
        
    }
    
    /// calculateVolume
    /// - Parameters:
    ///   - lower: array of lower limits in space of the box, count should be equal to or greater than the dimensions
    ///   - upper: array of upper limits in space of the box, count should be equal to or greater than the dimensions
    ///   - dimensions: number of Dimensions of the box
    ///   returns the volume of the multidimensional box
    func calculateVolume(lower: [Double], upper: [Double], dimensions: Int) -> Double {
        
        var theVolume :Double = 1.0
        var safeToCalculate = false
        
        if lower.count >= dimensions{
            
            safeToCalculate = true
            
        }
        
        if (upper.count >= dimensions && safeToCalculate) {
            
            safeToCalculate = true
            
            
        }
        else{
            
            safeToCalculate = false
            print("The limits did not match the number of dimensions.")
        }
        
        if (safeToCalculate){
            
            for i in 0 ..< dimensions{
                
                theVolume *= (upper[i] - lower[i])
                
            }
            
            
        }
        else{
            
            theVolume = 1.0
            print("theVolume value is incorrect.")
        }
        
        return (theVolume)
    }
 
    

}
