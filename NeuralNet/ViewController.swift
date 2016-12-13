//
//  ViewController.swift
//  NeuralNet
//
//  Created by Dmytro Yashkir on 2016-12-09.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import UIKit

import Surge

class ViewController: UIViewController {
    
    var neuralNet : NeuralNet?
    
    func realNetwork() {
        let trainingDataCSVPath = Bundle.main.path(forResource: "mnist_train_100", ofType: "csv")!
        let testDataCSVPath = Bundle.main.path(forResource: "mnist_test_10", ofType: "csv")!
        //print(trainingDataCSVPath)
        let urlTest = URL(fileURLWithPath: testDataCSVPath)
        
        var testData = [SampleData]()
        
        do{
            var testDataStr = try String(contentsOf: urlTest)
            
            let linesT = testDataStr.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
            
            testData = linesT.map{return SampleData(dataString: $0)!}
            
            //print(trainingData)
        }catch{
            return
        }
        
        
        
        
        let url = URL(fileURLWithPath: trainingDataCSVPath)
        
        var trainingData : [SampleData]?
        
        do{
            var trainingDataStr = try String(contentsOf: url)
            
            let lines = trainingDataStr.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
            
            trainingData = lines.map{return SampleData(dataString: $0)!}
            
            //print(trainingData)
        }catch{
            return
        }
        self.neuralNet = NeuralNet(nodeCountInput: 784, nodeCountHidden: 100, nodeCountOutput: 10, learningRate: 0.3)
        
        if let data = trainingData{
            for d in data{
                neuralNet?.train(inputs: d.data, outputs: d.outputs())
                //print("Trained: \(d.label)")
            }
        }
        
        
        //test
        var scorecard = Array.init(repeating: 0.0, count: (testData.count))
        
        for i in 0..<testData.count{
            let o : [Double] = (neuralNet?.query(inputs: (testData[i].data)))!
            let solution = o.max()
            let value = o.index(of: solution!)
            
            if testData[i].label == value {
                scorecard[i] = 1
            }
        }
        
        //print(scorecard)
        
        print("Score: \(scorecard.reduce(0, +)/Double(scorecard.count))")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
       /*
        self.neuralNet = NeuralNet(nodeCountInput: 3, nodeCountHidden: 3, nodeCountOutput: 3, learningRate: 0.5)
        
        if let n = neuralNet{
            let a = n.query(inputs: [[0.1], [0.2], [0.3]])
            print("************************************************")
            print(a)
        }
        */
        //neuralNet?.train(inputs: [[0.1], [0.2], [0.3]], outputs: [[0.1], [0.2], [0.3]])
        
        realNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

