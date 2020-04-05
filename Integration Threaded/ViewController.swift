//
//  ViewController.swift
//  Integration Threaded
//
//  Created by Jeff Terry on 3/27/20.
//  Copyright © 2020 Jeff Terry. All rights reserved.
//

import Cocoa
import os.log

class ViewController: NSViewController {
    
    var integral = 0.0
    var iterations = 0.0
    var totalGuesses = 0.0
    var guesses = 0.0
    var error = 0.0
    var dimensions = 1.0
    //integral e^-x from 0 to 1
    var exact = -exp(-1.0)+exp(0.0)
    
    var functionForIntegration: integrationFunctionHandler = eToTheMinusX
    
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "InformationJt")
    
    var start = DispatchTime.now() //Start time
    var stop = DispatchTime.now()  //Stop time
    
    var nanotime :UInt64 = 0
    var timeInterval : Double = 0.0
    var limitsOfIntegration = ([0.0], [1.0])
    
  
    @IBOutlet weak var integrateButton: NSButton!
    @IBOutlet var limitsOfIntegrationText: NSTextView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var selectionFunction: NSPopUpButton!
    @IBOutlet weak var integralValue: NSTextField!
    @IBOutlet weak var numberOfGuesses: NSTextField!
    @IBOutlet weak var numberOfIterations: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectionFunction.removeAllItems()
        selectionFunction.addItems(withTitles: ["exp(-x)", "exp(x)", "10DIntegral"]   )
        limitsOfIntegrationText.string = "0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n"
        numberOfGuesses.stringValue = "3200"
        numberOfIterations.intValue = 16
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func functionSelector(_ sender: Any) {
        
        switch selectionFunction.titleOfSelectedItem {
            
        case "exp(x)":
            dimensions = 1
            exact = exp(1.0) - exp(0.0)
            functionForIntegration = eToTheX
            
        case "10DIntegral":
            dimensions = 10
            exact = 155.0/6.0
            functionForIntegration = tenDIntegral
            
        case "exp(-x)":
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
        default:
            
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    /// startTheIntegration
    /// - Parameter sender: normally integration button in the GUI
    /// starts the multidimensional integration
    @IBAction func startTheIntegration(_ sender: Any) {
        
        //get limits of Integration
        let integrationLimitString = limitsOfIntegrationText.string
        limitsOfIntegration = parseString(stringWithParameters: integrationLimitString, separator: ", ")
        
        //test to make sure the number of Dimensions matches the number of Integration Limits
        //matches equals or exceeds.
        
        var safeToCalculate = false
        let numberOfLowerLimits = limitsOfIntegration.0.count
        let numberOfUpperLimits = limitsOfIntegration.1.count
        
        if(numberOfLowerLimits >= Int(dimensions)){
            
            safeToCalculate = true
        }
        
        if ((numberOfUpperLimits >= Int(dimensions) && safeToCalculate)){
            
            safeToCalculate = true
            
            
        }
        else{
            
            safeToCalculate = false
        }
        
        if !safeToCalculate {
            
            
            print("There was an error in the limits of integration.")
            return
        }
        
        
        
        let theIterations = numberOfIterations.intValue
        iterations = Double(theIterations)
        
        let myGuesses = numberOfGuesses.intValue
        print (myGuesses)
        
        start = DispatchTime.now() // starting time of the integration
        progressIndicator.startAnimation(self)
        
        integrateButton.isEnabled = false
        
        let myQueue = DispatchQueue.init(label: "integrationQueue", qos: .userInitiated, attributes: .concurrent)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            
            self.integration(iterations: theIterations, guesses: myGuesses, lowerLimit:self.limitsOfIntegration.0, upperLimit:self.limitsOfIntegration.1, theQueue: myQueue)
            
        }
        
        print("done")
        
    }
    
    /// integration
    /// does the heavily lifting and performs the threaded Monte Carlo Integration
    /// - Parameters:
    ///   - iterations: number of iterations
    ///   - guesses: number of guesses
    ///   - lowerLimit: array of the lower limits of integration should be >= number of dimensions
    ///   - upperLimit: array of the upper limits of integration should be >= number of dimensions
    ///   - theQueue: DispatchQueue in which we will perform the threaded integration. This can be concurrent or synchrous as needed. Testing usally synchronously. Calculations done concurrently.
    func integration(iterations: Int32, guesses: Int32, lowerLimit:[Double], upperLimit:[Double], theQueue: DispatchQueue){
        
        var integralArray :[Double] = []
        
        theQueue.async{
            
            DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
                
                print("started index \(index)")
                
                integralArray.append(calculateMonteCarloIntegral(dimensions: Int(self.dimensions), guesses: guesses, lowerLimit: lowerLimit, upperLimit: upperLimit, functionToBeIntegrated: self.functionForIntegration))
                
                
            })
            
        //Calculate the Volume of the Multidimensional Box
            
        let myVolume = BoundingBox()
        
        myVolume.initWithDimensionsAndRanges(dimensions: Int(self.dimensions), lowerBound: lowerLimit, upperBound: upperLimit)
        
        
        let volume = myVolume.volume
        
        let integralValue = integralArray.map{$0 * (volume / Double(guesses))}
        
        print(integralValue)
        
        let myIntegral = integralValue.mean
        
        print("integral is \(myIntegral) exact is \(self.exact)")
            
        self.integral = myIntegral
        
        DispatchQueue.main.async{
            
            self.integralValue.doubleValue = myIntegral
            self.stop = DispatchTime.now()    //end time
            
            self.progressIndicator.stopAnimation(self)
            self.integrateButton.isEnabled = true
            
            self.nanotime = self.stop.uptimeNanoseconds - self.start.uptimeNanoseconds //difference in nanoseconds from the start of the calculation until the end.
            
            self.timeInterval = Double(self.nanotime) / 1_000_000_000
            
            print("Time to evaluate was: \(self.timeInterval) seconds.")
            os_log("Time to evaluate was:: %5.5f seconds.", log: self.log, self.timeInterval)
            
            
            
            
            
        }
            
        
        
        
        }
        
        
    }
    
    
        
        


    
}

