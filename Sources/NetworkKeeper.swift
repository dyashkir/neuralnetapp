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
    
    var trainingData : [SampleData]?
    var testData : [SampleData]?
    
    static let sharedSingleton = { () -> NetworkKeeper in
        let tr : NetworkKeeper = NetworkKeeper()
        return tr
    }()

    func readFile(path: String) -> String {

      do {

        let text = try String(contentsOfFile: path)
          return text
      }catch{
        fatalError()
      }
    }

    func CSVNumbersDataParseLine(line: [String]) -> (Int, [Double]) {
        let dd = line[1..<line.count].map { b in
            return Double(b)!
        }
        let r = (Int(line[0])!, dd)
        return r
    }

    func importCSV(csvstring : String) ->[SampleData]{
        
        var lines = csvstring.components(separatedBy: "\n").map( { a in
            return a.components(separatedBy: ",")
        })
        
        lines = Array(lines[0..<(lines.count-1)])
        
        return lines.map { a in
            let line = CSVNumbersDataParseLine(line: a)
            return SampleData(label: line.0, data: line.1)
        }
        
    }
    
    func loadData(){
        
        let testCSV = readFile(path: "/Users/dyashkir/ios/NeuralNet/test_train_data/mnist_test.csv")
        let trainingCSV = readFile(path: "/Users/dyashkir/ios/NeuralNet/test_train_data/mnist_train.csv")
        
        
        self.trainingData = importCSV(csvstring: trainingCSV)
        
        self.testData = importCSV(csvstring: testCSV)
    }

    
    func initNetwork(){
        self.neuralNet = NeuralNet(nodeCountInput: 784, nodeCountHidden: 100, nodeCountOutput: 10, learningRate: 0.3)
    }
    
    func train(updateFunc : (Double)->()) {
       
        if let trainingData = self.trainingData {
            
            var now = 0.0
            let step = 1.0/Double(trainingData.count)
            for d in trainingData{
                neuralNet?.train(inputs: d.data, outputs: d.outputs())
                updateFunc(now)
                now = now+step
            }
            
        }
    }
    //test
    func test()->Double{
        if let testData = self.testData{
            var scorecard = Array.init(repeating: 0.0, count: (testData.count))
            
            for i in 0..<testData.count{
                let o : [Double] = (neuralNet?.query(inputs: (testData[i].data)))!
                let solution = o.max()
                let value = o.index(of: solution!)
                
                if testData[i].label == value {
                    scorecard[i] = 1
                }
            }
            
            return scorecard.reduce(0, +)/Double(scorecard.count)
        }else{
            return 0.0
        }
    }
}
