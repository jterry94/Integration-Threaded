//
//  testParser.swift
//  Integration Threaded
//
//  Created by Jeff Terry on 4/4/20.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Foundation

/// parseString
/// - Parameters:
///   - stringWithParameters: string with parameters that should contain lower and upper limits for each dimension
///   - separator: separator separating parameter values could by ", ", " ", "\t" etc
func parseString(stringWithParameters: String, separator: String) -> ([Double], [Double]){
    
    //function parses a string of the form "x.x" + "separator" + "y.y\n"
    //function needs to be passes a separator in this case we will use ", "
    
    var lowerBound :[Double] = []
    var upperBound :[Double] = []
    
    do {
        
        //read the string of boundary parameters from the string that we pass in
        var contentsArray: [String] = stringWithParameters.components(separatedBy: "\n")
        
        //remove any empty values
        contentsArray = contentsArray.filter({$0 != ""})
        
        for i in 0 ..< contentsArray.count {
            
            var configurationString :[String] = contentsArray[i].components(separatedBy: separator)
            
            //remove any empty elements
            configurationString = configurationString.filter({$0 != ""})
            
            if let lower = Double(configurationString[0]){
                
                lowerBound.append(lower)
                
            }
            else {
                
                print("Not a valid number \(configurationString[0])")
                
            }
            if let upper = Double(configurationString[1]){
                
                upperBound.append(upper)
                
                
            }
            else {
                
                
                print("Not a valid number \(configurationString[1])")
                
                
            }
            
            
            
            
        }
        
        
        
    }
 
    return( lowerBound, upperBound)
    
}
