//
//  MonteCarloIntegration.swift
//  Integration Threaded
//
//  Created by Jeff Terry on 3/30/20.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Foundation

typealias integrationFunctionHandler = (_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double

/// calculateMonteCarloIntegral
/// - Parameters:
///   - dimensions: number of dimensions
///   - guesses: number of guesses in each iteration
///   - lowerLimit: lower bound of the integration, needs one value per each dimension
///   - upperLimit: upper bound of the integration, needs one value per each dimension
///   - functionToBeIntegrated: passed in function to be integrated over the range lowerLimit to UpperLimit. Must be of type integrationFunctionHandler
func calculateMonteCarloIntegral(dimensions: Int, guesses: Int32, lowerLimit: [Double], upperLimit: [Double], functionToBeIntegrated: integrationFunctionHandler) -> Double{

        var currentIntegral = 0.0
        var parameters :[Double] = []
    
    for _ in 0 ..< guesses{
            
            for j in 0 ..< dimensions{
                
                parameters.append(Double.random(in: (lowerLimit[j] ... upperLimit[j])))
                
            }
            
            currentIntegral += functionToBeIntegrated(dimensions, parameters)
            parameters.removeAll()
        
        }
        

        return(currentIntegral)

}

/// eToTheMinusX
/// - Parameters:
///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
///   - arrayOfInputs: input for each dimension to be calculated in this case only 1st is used. Must be an array to match type integrationFunctionHandler
/// returns the value of exp(-x)
func eToTheMinusX(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
    
    if numberOfDimensions == 1 {
        
        return (exp(-arrayOfInputs[0]))
        
        
        
    }
    
    else {
        
        print("The dimensions do not match for 1D exp(-x).")
        
        
    }
    
    return (0.0)
    
    
}

/// eToTheX
/// - Parameters:
///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
///   - arrayOfInputs: input for each dimension to be calculated in this case only 1st is used. Must be an array to match type integrationFunctionHandler
/// returns the value of exp(x)
func eToTheX(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
    
    if numberOfDimensions == 1 {
        
        return (exp(arrayOfInputs[0]))
        
        
        
    }
    
    else {
        
        print("The dimensions do not match for 1D exp(-x).")
        
        
    }
    
    return (0.0)
    
    
}

/// tenDIntegral
/// - Parameters:
///   - numberOfDimensions: number of dimensions to match type integrationFunctionHandler
///   - arrayOfInputs: input for each dimension to be calculated. Must be an array to match type integrationFunctionHandler
///                                                             2
///  return    (x  + x  + x  + x  + x  + x  + x  + x  + x  + x )
///              0    1    2    3    4    5    6    7    8    9
func tenDIntegral(_ numberOfDimensions: Int, _ arrayOfInputs: [Double]) -> Double {
    
    
    if numberOfDimensions == 10 {
        //(x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9)^2
        
        let total = arrayOfInputs.reduce(0, +)
        
        return(pow(total, 2.0))
        
    }
    else {
        
        print("The dimensions of the 10D Integration were not equal to 10.")
        
    }
    
    return (0.0)

}


