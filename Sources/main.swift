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
/*
@IBAction func testButtonPressed(_ sender: Any) {
        NetworkKeeper.sharedSingleton.test(
            onFinish: { b  in
                self.testResultLabel.text = "Score: \(b)"
        })
    }
*/
 // let serialQueue = DispatchQueue(label: "com.queue.Serial")
  //      serialQueue.async {
  NetworkKeeper.sharedSingleton.train(updateFunc:
                { a in
NSLog("*")
},

                             onFinish: { _ in return })
        }
    }
