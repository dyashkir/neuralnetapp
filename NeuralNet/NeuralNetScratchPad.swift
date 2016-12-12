//
//  NeuralNetScratchPad.swift
//  NeuralNet
//
//  Created by Dmytro Yashkir on 2016-12-09.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import Foundation
import Surge

struct SampleData {
    
    let label : Int
    var data = [Double]()
    
    init?(dataString :String){
        
        let strs : [String] = dataString.characters.split { $0 == "\n" || $0 == "," }.map(String.init)
        if let label = strs.first, let d = Int(label) {
            self.label = d
        }else{
            return nil
        }
        
        for i in 1..<strs.count {
            if let d = Double(strs[i]){
                data.append(d)
            }else{
                return nil
            }
        }
        //normalize
        data = data.map{$0/255.0*0.99+0.01}
        
    }
    
    func outputs() -> [Double] {
        var out = Array<Double>(repeating: 0.01, count: 10)
        out[label] = 0.99
        return out
    }
}

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
        
        print("Intial weights")
        //print(self.weightsInputToHidden)
        //print(self.weightsHiddenToOutput)
    }
    
    
    func activation(_ x:Double) -> Double {
        let sigmoid = 1.0/(1.0+Surge.exp(-x))
        return sigmoid
    }
    
    
    mutating func train(inputs : [Double], outputs : [Double]){
        //let result = self.query(inputs: inputs)
        
        let inp = Surge.transpose(Matrix([inputs]))
        let target = Surge.transpose(Matrix([outputs]))
        
        let hiddenInputs = Surge.mul(self.weightsInputToHidden, y: inp)
        
        let hiddenOutputs = Surge.applyD(hiddenInputs, function: activation)
        
        let outputInputs = Surge.mul(self.weightsHiddenToOutput, y: hiddenOutputs)
        
        let output = Surge.applyD(outputInputs, function: activation)
        
        

        //Errors
        let outputError = target+(-1.0*output)
        let hiddenError = Surge.mul(Surge.transpose(self.weightsHiddenToOutput), y: outputError)
        
        
        //adjust hidden to out
        let a1 = Surge.elmul(Surge.elmul(outputError, y: output), y: Surge.applyD(output, function:{return 1-$0}))
        
        let adjust = self.learningRate * Surge.mul(a1, y: Surge.transpose(hiddenOutputs))
        
        self.weightsHiddenToOutput = self.weightsHiddenToOutput + adjust
        
        //adjust out to hidden
        
        let a2 = Surge.elmul(Surge.elmul(hiddenError, y: hiddenOutputs), y: Surge.applyD(hiddenOutputs, function:{return 1-$0}))
        
        let adjust2 = self.learningRate * Surge.mul(a2, y: Surge.transpose(inp))
        
        self.weightsInputToHidden = self.weightsInputToHidden + adjust2
        
        //print("Adjusted")
        //print(self.weightsHiddenToOutput)
        //print(self.weightsInputToHidden)
        
    }
    
    func query(inputs: [Double]) -> Matrix<Double>{
        
        let inp = Surge.transpose(Matrix([inputs]))
        
        
        let hiddenInputs = Surge.mul(self.weightsInputToHidden, y: inp)
        
        
        let hiddenOutputs = Surge.applyD(hiddenInputs, function: activation)
        
        let outputInputs = Surge.mul(self.weightsHiddenToOutput, y: hiddenOutputs)
        
        let output = Surge.applyD(outputInputs, function: activation)
        
        return output
        
    }
    
}
