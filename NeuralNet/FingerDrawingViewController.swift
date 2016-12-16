//
//  FingerDrawingViewController.swift
//  NeuralNet
//
//  Created by Dmytro Yashkir on 2016-12-15.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import UIKit
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImage {
    func sampleImage() -> [Double]{
        var sample = [Double]()
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        for y in 0..<28 {
            for x in 0..<28{
                let qx = CGFloat(x)*self.size.height/28
                let qy = CGFloat(y)*self.size.width/28
                
                let pixelInfo: Int = ((Int(self.size.width) * Int(qy)) + Int(qx)) * 4
                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                sample.append(Double(r+g+b)/3.0)
            }
        }
        
        return sample
        
    }
}

class FingerDrawingViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    //drawing properties
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.7
    var blue: CGFloat = 0.4
    var brushWidth: CGFloat = 50.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    @IBAction func queryButtonPress(_ sender: Any) {
        if let image = imageView.image {
            
            let sample = image.sampleImage()
            print(sample)
            
            let res : [Double] = (NetworkKeeper.sharedSingleton.neuralNet?.query(inputs: sample))!
            
            print(res)
            
        }
        
    }
    @IBAction func clearButton(_ sender: Any) {
        imageView.image = nil
    }
    
    //MARK: finger drawing business
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.imageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        
        imageView.image?.draw(in: imageView.bounds)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context.setBlendMode(CGBlendMode.normal)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            imageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            self.drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
