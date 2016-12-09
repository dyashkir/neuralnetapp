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
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.neuralNet = NeuralNet(nodeCountInput: 3, nodeCountHidden: 3, nodeCountOutput: 3, learningRate: 0.5)
        
        if let n = neuralNet{
            let a = n.query(inputs: [[0.1], [0.2], [0.3]])
            
            
            print("************************************************")
            print(a)
        }
        
        neuralNet?.train(inputs: [[0.1], [0.2], [0.3]], outputs: [[0.1], [0.2], [0.3]])
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

