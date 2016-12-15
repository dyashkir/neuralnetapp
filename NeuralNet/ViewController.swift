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
    
    @IBAction func testButtonPressed(_ sender: Any) {
        NetworkKeeper.sharedSingleton.test(
            onFinish: { b  in
                self.testResultLabel.text = "Score: \(b)"
        })
    }
    @IBAction func trainButtonPressed(_ sender: Any) {
        progressIndicator.setProgress(0.0, animated: false)
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        serialQueue.async {
            NetworkKeeper.sharedSingleton.train(updateFunc:
                { a in
                    DispatchQueue.main.async{self.progressIndicator.setProgress(Float(a), animated: true)}},
                             onFinish: { _ in return })
        }
    }

    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

