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

    let trainingCSV = readFile(path: "/Users/dyashkir/ios/GPSwift/train_test_data/mnist_train.csv")

      var lines = trainingCSV.components(separatedBy: "\n").map( { a in
          return a.components(separatedBy: ",")
          })

    lines = Array(lines[0..<(lines.count-1)])

    
    func loadData(){
        
        func mapper(recordValues : [String]) -> SampleData{
            let vals : [Double] = recordValues[1..<recordValues.count].map({return Double($0)!})
            return SampleData(label: Int(recordValues[0])!, data: vals)
        }
        
        let trainingDataCSVPath = Bundle.main.path(forResource: "mnist_train", ofType: "csv")!
        let trainingImporter = CSVImporter<SampleData>(path: trainingDataCSVPath)
        
        
        trainingImporter.startImportingRecords( mapper: mapper).onFinish { importedRecords in
                self.trainingData = importedRecords
        }
        
        let testDataCSVPath = Bundle.main.path(forResource: "mnist_test_10", ofType: "csv")!
        let testingImporter = CSVImporter<SampleData>(path: testDataCSVPath)
        
        testingImporter.startImportingRecords( mapper: mapper).onFinish { importedRecords in
                self.testData = importedRecords
        }
    }

    
    func initNetwork(){
        self.neuralNet = NeuralNet(nodeCountInput: 784, nodeCountHidden: 100, nodeCountOutput: 10, learningRate: 0.3)
    }
    
    func train(updateFunc : (Double)->(), onFinish: (Double)->()) {
       
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
    func test(onFinish: (Double)->()){
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
            
            onFinish(scorecard.reduce(0, +)/Double(scorecard.count))
        }
    }
}
