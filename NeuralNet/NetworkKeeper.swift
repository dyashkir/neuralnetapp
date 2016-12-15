//
//  NetworkKeeper.swift
//  NeuralNet
//
//  Created by Dmytro Yashkir on 2016-12-15.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import Foundation

class NetworkKeeper {
    
    var neuralNet: NeuralNet?
    
    let trainingData : [SampleData]
    let testData : [SampleData]
    
    static let sharedSingleton = { () -> NetworkKeeper in
        let tr : NetworkKeeper = NetworkKeeper()
        
        
        return tr
    }()
    
    init(){
        let testDataCSVPath = Bundle.main.path(forResource: "mnist_test_10", ofType: "csv")!
        let trainingDataCSVPath = Bundle.main.path(forResource: "mnist_train_100", ofType: "csv")!
        
        trainingData = SampleData.loadDataFromCSV(urlString: trainingDataCSVPath)
        testData = SampleData.loadDataFromCSV(urlString: testDataCSVPath)
    }
    
    
    func initNetwork(){
        self.neuralNet = NeuralNet(nodeCountInput: 784, nodeCountHidden: 100, nodeCountOutput: 10, learningRate: 0.3)
    }
    
    func train(updateFunc : (Double)->(), onFinish: (Double)->()) {
        
        
        var now = 0.0
        let step = 1.0/Double(trainingData.count)
        for d in trainingData{
            neuralNet?.train(inputs: d.data, outputs: d.outputs())
            updateFunc(now)
            now = now+step
        }
        
        
    }
    //test
    func test(onFinish: (Double)->()){
        var scorecard = Array.init(repeating: 0.0, count: (testData.count))
        
        for i in 0..<testData.count{
            let o : [Double] = (neuralNet?.query(inputs: (testData[i].data)))!
            let solution = o.max()
            let value = o.index(of: solution!)
            
            if testData[i].label == value {
                scorecard[i] = 1
            }
        }
        
        //print("Score: \(scorecard.reduce(0, +)/Double(scorecard.count))")
        onFinish(scorecard.reduce(0, +)/Double(scorecard.count))
    }
}
