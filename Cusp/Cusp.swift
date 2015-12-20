//
//  Cusp.swift
//  Cusp
//
//  Created by Vishal V Shekkar on 21/12/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

enum StartQuadrant: Int {
    
    case BottomRight = 1
    case BottomLeft
    case TopLeft
    case TopRight
    
}

enum Direction: Int {
    
    //When viewing perpendicular to the front of the screen
    case ClockWise = 1
    case AntiClockwise = 2
    
}

struct Cusp {
    
    /*
    Always returns angle in StartQuadrant.BottomRight quadrant and Direction.Clockwise direction
    Use methods in Angle struct to modify these properties and convert angles accordingly
    
    The Angle Returned is nil if 'toLine' does not have one of the points same as 'center'
    */
    static func getAngle(center: CGPoint, toLine: Line) -> Angle? {
        
        let baseLine = Line(pointA: center, pointB: CGPoint(x: center.x + 500, y: center.y))
        return Cusp.getAngleBetweenLines(baseLine, toLine: toLine)
        
    }
    
    static func getAngleBetweenLines(baseLine: Line, toLine: Line) -> Angle? {
        
        if let originPoint = baseLine.hasCommonPointWith(toLine) {
            let otherPoint = toLine.getPoint(originPoint)
            let adjacentDistance = originPoint.distanceToPoint(CGPoint(x: otherPoint.x, y: originPoint.y))
            let oppositeDistance = otherPoint.distanceToPoint(CGPoint(x: otherPoint.x, y: originPoint.y))
            let radianAngleBetweenLines = Radian(radian: atan(oppositeDistance/adjacentDistance))
            let angleBetweenLinesWithoutQuadrantManagement = Angle(degree: radianAngleBetweenLines.convertToDegree(), startQuadrant: .BottomRight, direction: .ClockWise)
            let angleBetweenLines = Cusp.handleQuadrant(originPoint, pointMakingAngle: otherPoint, angle: angleBetweenLinesWithoutQuadrantManagement)
            return angleBetweenLines
        }
        else {
            return nil
        }
        
    }
    
    private static func handleQuadrant(origin: CGPoint, pointMakingAngle: CGPoint, angle: Angle) -> Angle {
        
        var angleToReturn = angle
        //Bottom Right Quadrant
        if pointMakingAngle.x >= origin.x && pointMakingAngle.y >= origin.y {
            
        }
            //Bottom Left Quadrant
        else if pointMakingAngle.x < origin.x && pointMakingAngle.y >= origin.y {
            let degreeAngleInQuadrant = Degree(degree: 180 - angle.degree.degree)
            angleToReturn = Angle(degree: degreeAngleInQuadrant, startQuadrant: .BottomRight, direction: .ClockWise)
        }
            //Top Left Quadrant
        else if pointMakingAngle.x < origin.x && pointMakingAngle.y < origin.y {
            let degreeAngleInQuadrant = Degree(degree: 180 + angle.degree.degree)
            angleToReturn = Angle(degree: degreeAngleInQuadrant, startQuadrant: .BottomRight, direction: .ClockWise)
        }
            //Top Right Quadrant
        else if pointMakingAngle.x >= origin.x && pointMakingAngle.y < origin.y {
            let degreeAngleInQuadrant = Degree(degree: 360 - angle.degree.degree)
            angleToReturn = Angle(degree: degreeAngleInQuadrant, startQuadrant: .BottomRight, direction: .ClockWise)
        }
        return angleToReturn
        
    }
    
}

struct Degree {
    
    var degree: CGFloat
    
    func addDegree(degreeToAdd: CGFloat) -> Degree {
        var newDegree = degree + degreeToAdd
        if newDegree > 360 {
            newDegree = newDegree%360
        }
        else if newDegree < 0 {
            let degreeToSubtract = (newDegree * -1)%360
            newDegree = 360 - degreeToSubtract
        }
        return Degree(degree: newDegree)
    }
    
    func convertToRadian() -> Radian {
        return Radian(radian: self.degree.degreeToRadian())
    }
}

struct Radian {
    
    var radian: CGFloat
    
    func addradian(radianToAdd: CGFloat) -> Radian {
        let degree = Degree(degree: radian.radianToDegree())
        let degreeToAdd = radianToAdd.radianToDegree()
        return degree.addDegree(degreeToAdd).convertToRadian()
    }
    
    func convertToDegree() -> Degree {
        return Degree(degree: self.radian.radianToDegree())
    }
}

struct Angle {
    
    var degree: Degree
    var radian: Radian {
        get {
            return degree.convertToRadian()
        }
        set {
            degree = radian.convertToDegree()
        }
    }
    var startQuadrant: StartQuadrant = .BottomRight
    var direction: Direction = .ClockWise
    
    func moveOneQuadrantForward() -> Angle {
        var newStartQuadrant: StartQuadrant
        let newDegreeAngle = degree.addDegree(-90)
        switch startQuadrant {
        case .BottomRight:
            if direction == .ClockWise {
                newStartQuadrant = .BottomLeft
            }
            else {
                newStartQuadrant = .TopRight
            }
        case .BottomLeft:
            if direction == .ClockWise {
                newStartQuadrant = .TopLeft
            }
            else {
                newStartQuadrant = .BottomRight
            }
        case .TopLeft:
            if direction == .ClockWise {
                newStartQuadrant = .TopRight
            }
            else {
                newStartQuadrant = .BottomLeft
            }
        case .TopRight:
            if direction == .ClockWise {
                newStartQuadrant = .BottomRight
            }
            else {
                newStartQuadrant = .TopLeft
            }
        }
        return Angle(degree: newDegreeAngle, startQuadrant: newStartQuadrant, direction: direction)
    }
    
    func moveOneQuadrantBackward() -> Angle {
        var angleToChangeQuadrant = self
        for _ in 1...3 {
            angleToChangeQuadrant = angleToChangeQuadrant.moveOneQuadrantForward()
        }
        return angleToChangeQuadrant
    }
    
    func switchDirection() -> Angle {
        var newDirection: Direction
        let newDegreeAngle = Degree(degree: 360).addDegree(-self.degree.degree)
        if self.direction == .ClockWise {
            newDirection = .AntiClockwise
        }
        else {
            newDirection = .ClockWise
        }
        return Angle(degree: newDegreeAngle, startQuadrant: self.startQuadrant, direction: newDirection)
    }
    
}

struct Line {
    
    var pointA: CGPoint
    var pointB: CGPoint
    
    func hasCommonPointWith(line: Line) -> CGPoint? {
        let lineAPoints = [self.pointA, self.pointB]
        let lineBPoints = [line.pointA, line.pointB]
        if self.pointA.isEqualTo(self.pointB) || line.pointA.isEqualTo(line.pointB) {
            return nil
        }
        for aPoint in lineAPoints {
            for bPoint in lineBPoints {
                if aPoint.isEqualTo(bPoint) {
                    return aPoint
                }
            }
        }
        return nil
    }
    
    func getPoint(otherThanPoint: CGPoint) -> CGPoint {
        if self.pointA.isEqualTo(otherThanPoint) {
            return self.pointB
        }
        else {
            return self.pointA
        }
    }
}

extension CGPoint {
    
    func getDifferenceWithPoint(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func getPointAfterAddingDifference(difference: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + difference.x, y: self.y + difference.y)
    }
    
    func distanceToPoint(point: CGPoint) -> CGFloat {
        let xSquareDistance = pow((self.x - point.x), 2)
        let ySquareDistance = pow((self.y - point.y), 2)
        return sqrt(xSquareDistance + ySquareDistance)
    }
    
    func isEqualTo(point: CGPoint) -> Bool {
        if self.x == point.x && self.y == point.y {
            return true
        }
        else {
            return false
        }
    }
}

extension CGFloat {
    
    func degreeToRadian() -> CGFloat {
        return self * CGFloat(M_PI/180)
    }
    
    func radianToDegree() -> CGFloat {
        return self * CGFloat(180/M_PI)
    }
    
}
