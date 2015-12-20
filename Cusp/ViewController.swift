//
//  ViewController.swift
//  Cusp
//
//  Created by Vishal V Shekkar on 21/12/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var radianLabel: UILabel!
    @IBOutlet weak var canvas: UIView!
    
    var panGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        canvas.addGestureRecognizer(panGesture!)
    }
    
    func panGestureRecognized(gesture: UIPanGestureRecognizer) {
        let fingerLocation = gesture.locationInView(canvas)
        let origin = CGPoint(x: canvas.frame.width/2, y: canvas.frame.height/2)
        let fingerLine = Line(pointA: origin, pointB: fingerLocation)
        
        if let angle = Cusp.getAngle(origin, toLine: fingerLine) {
            degreeLabel.text = "Degree: " + "\(angle.degree)"
            radianLabel.text = "Radian: " + "\(angle.radian)"
        }
        else {
            degreeLabel.text = "Degree: --"
            radianLabel.text = "Radian: --"
        }
    }

}

