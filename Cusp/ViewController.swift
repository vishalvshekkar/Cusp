//
//  ViewController.swift
//  Cusp
//
//  Created by Vishal V Shekkar on 21/12/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startQuadrantSegmentControl: UISegmentedControl!
    @IBOutlet weak var directionSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var bottomline: UIView!
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var radianLabel: UILabel!
    
    @IBOutlet weak var canvas: UIView!
    
    private var direction = Direction.ClockWise
    private var startQuadrant = StartQuadrant.BottomRight
    var panGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        canvas.addGestureRecognizer(panGesture!)
        startQuadrantSegmentControl.selectedSegmentIndex = 0
        directionSegmentControl.selectedSegmentIndex = 0
        manageLineHighlight()
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

    @IBAction func didSelectSegment(sender: AnyObject) {
        
        if (sender as? UISegmentedControl) == startQuadrantSegmentControl {
            startQuadrant = StartQuadrant(rawValue: startQuadrantSegmentControl.selectedSegmentIndex + 1)!
        }
        else if (sender as? UISegmentedControl) == directionSegmentControl {
            direction = Direction(rawValue: directionSegmentControl.selectedSegmentIndex + 1)!
        }
        manageLineHighlight()
        
    }
    
    private func manageLineHighlight() {
        let defaultColor = UIColor(white: 1.0, alpha: 0.3)
        topLine.backgroundColor = defaultColor
        leftLine.backgroundColor = defaultColor
        rightLine.backgroundColor = defaultColor
        bottomline.backgroundColor = defaultColor
        
        switch startQuadrant {
        case .BottomRight:
            if direction == .ClockWise {
                rightLine.backgroundColor = UIColor.whiteColor()
            }
            else {
                bottomline.backgroundColor = UIColor.whiteColor()
            }
        case .BottomLeft:
            if direction == .ClockWise {
                bottomline.backgroundColor = UIColor.whiteColor()
            }
            else {
                leftLine.backgroundColor = UIColor.whiteColor()
            }
        case .TopLeft:
            if direction == .ClockWise {
                leftLine.backgroundColor = UIColor.whiteColor()
            }
            else {
                topLine.backgroundColor = UIColor.whiteColor()
            }
        case .TopRight:
            if direction == .ClockWise {
                topLine.backgroundColor = UIColor.whiteColor()
            }
            else {
                rightLine.backgroundColor = UIColor.whiteColor()
            }
        }
    }

}

