//
//  NeuralNetScratchPad.swift
//  NeuralNet
//
//  Created by Dmytro Yashkir on 2016-12-09.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import Foundation
import Surge

struct NeuralNet {
    
    let learningRate : Double
    
    let nodeCountInput : Int
    let nodeCountHidden : Int
    let nodeCountOutput : Int
    
    var weightsInputToHidden : Matrix<Double>
    var weightsHiddenToOutput : Matrix<Double>
    
    init(nodeCountInput: Int, nodeCountHidden: Int, nodeCountOutput: Int, learningRate: Double){
        self.nodeCountInput = nodeCountInput
        self.nodeCountHidden = nodeCountHidden
        self.nodeCountOutput = nodeCountOutput
        
        self.learningRate = learningRate
        
        
        self.weightsInputToHidden = Matrix(rows: nodeCountHidden, columns: nodeCountInput, valueFunc: { return (drand48() - 0.5)
            })
        
        self.weightsHiddenToOutput = Matrix(rows: nodeCountOutput, columns: nodeCountHidden, valueFunc:{ return (drand48() - 0.5)} )
    }
    
    
    func activation(_ x:Double) -> Double {
        let sigmoid = 1.0/(1.0+Surge.exp(-x))
        return sigmoid
    }
    
    
    func train(inputs : [[Double]], outputs : [[Double]]){
        let result = self.query(inputs: inputs)
        let target = Matrix(outputs)
        
        print("Target")
        print(target)
        print("Result")
        print(result)
        
        let error = target+(-1.0*result)
        
        
        print("Error is: ")
        print(error)
        
    }
    
    func query(inputs: [[Double]]) -> Matrix<Double>{
        
        let inp = Matrix(inputs)
        
        
        var hiddenInputs = Surge.mul(self.weightsInputToHidden, y: inp)
        hiddenInputs.apply(function: activation)
        
        let hiddenOutputs = hiddenInputs
        
        var outputInputs = Surge.mul(self.weightsHiddenToOutput, y: hiddenOutputs)
        
        outputInputs.apply(function: activation)
        
        let output = outputInputs
        
        return output
        
    }
    
}
