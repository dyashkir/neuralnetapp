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
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var progressIndicator: UIProgressView!
    
    @IBOutlet weak var testResultLabel: UILabel!
    var neuralNet : NeuralNet?
    
    @IBAction func trainButtonPressed(_ sender: Any) {
        progressIndicator.setProgress(0.0, animated: false)
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.async {
            self.realNetwork(updateFunc:
                { a in
                    DispatchQueue.main.async{self.progressIndicator.setProgress(Float(a), animated: true)}},
                             onFinish: { b  in
                     DispatchQueue.main.async{self.testResultLabel.text = "Score: \(b)"}})
            }
    }

    func loadDataFromCSV(urlString : String) -> [SampleData]{
        let urlTest = URL(fileURLWithPath: urlString)
        
        var data = [SampleData]()
        
        do{
            var dataStr = try String(contentsOf: urlTest)
            let linesT = dataStr.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
            data = linesT.map{return SampleData(dataString: $0)!}
        }catch{
            fatalError()
        }
        return data
    }
    
    private func realNetwork(updateFunc : (Double)->(), onFinish: (Double)->()) {
        let trainingDataCSVPath = Bundle.main.path(forResource: "mnist_train_100", ofType: "csv")!
        let testDataCSVPath = Bundle.main.path(forResource: "mnist_test_10", ofType: "csv")!
        
        let trainingData = loadDataFromCSV(urlString: trainingDataCSVPath)
        let testData = loadDataFromCSV(urlString: testDataCSVPath)
        
        self.neuralNet = NeuralNet(nodeCountInput: 784, nodeCountHidden: 100, nodeCountOutput: 10, learningRate: 0.3)
        
        var now = 0.0
        let step = 1.0/Double(trainingData.count)
        for d in trainingData{
            neuralNet?.train(inputs: d.data, outputs: d.outputs())
            updateFunc(now)
            now = now+step
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
        onFinish(scorecard.reduce(0, +)/Double(scorecard.count))
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

