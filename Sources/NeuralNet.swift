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
    
    
    init(label : Int, data : [Double]){
        self.label = label
        self.data = data.map{$0/255.0*0.99+0.01}
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
        
    }
    
    
    //node activation
    func activation(_ x:Double) -> Double {
        let sigmoid = 1.0/(1.0+pow(2.7182818, -x))
        return sigmoid
    }
    
    
    mutating func train(inputs : [Double], outputs : [Double]){
        
        //input and output
        let inp = Surge.transpose(Matrix([inputs]))
        let target = Surge.transpose(Matrix([outputs]))
        
        //calc hidden inputs and then activation
        let hiddenInputs = Surge.mul(self.weightsInputToHidden, y: inp)
        let hiddenOutputs = Surge.apply(hiddenInputs, function: activation)
        
        //output inputs and then activation
        let outputInputs = Surge.mul(self.weightsHiddenToOutput, y: hiddenOutputs)
        let output = Surge.apply(outputInputs, function: activation)

        //Errors
        let outputError = target+(-1.0*output)
        let hiddenError = Surge.mul(Surge.transpose(self.weightsHiddenToOutput), y: outputError)
        
        //adjust hidden to out
        let adjustHO = self.learningRate *
            Surge.mul(
                Surge.elmul(
                    Surge.elmul(outputError, y: output),
                    y: Surge.apply(output, function:{return 1-$0})),
                y: Surge.transpose(hiddenOutputs))
        
        self.weightsHiddenToOutput = self.weightsHiddenToOutput + adjustHO
        
        //adjust out to hidden
        
        let adjustIH = self.learningRate *
            Surge.mul(
                Surge.elmul(
                    Surge.elmul(hiddenError, y: hiddenOutputs),
                    y: Surge.apply(hiddenOutputs, function:{return 1-$0})),
                y: Surge.transpose(inp))
        
        self.weightsInputToHidden = self.weightsInputToHidden + adjustIH
        
    }
    
    func query(inputs: [Double]) -> Matrix<Double>{
        
        let inp = Surge.transpose(Matrix([inputs]))
        let hiddenInputs = Surge.mul(self.weightsInputToHidden, y: inp)
        
        
        let hiddenOutputs = Surge.apply(hiddenInputs, function: activation)
        
        let outputInputs = Surge.mul(self.weightsHiddenToOutput, y: hiddenOutputs)
        
        let output = Surge.apply(outputInputs, function: activation)
        
        return output
        
    }
    
    func query(inputs: [Double]) -> [Double]{
        let o:Matrix<Double> = self.query(inputs: inputs)
        return Surge.dump(matrix: o)
    }
}
