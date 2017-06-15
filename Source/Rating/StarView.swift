//
//  StarView.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 14/6/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation
import UIKit

public class StarView: UIView {
    
    public init(lineWidth: CGFloat, size: CGSize, strokeColor: UIColor, fillColor: UIColor) {
        super.init(frame: CGRect(origin: .zero, size: size))
        
        backgroundColor = .white
        
        let starLayer = CAShapeLayer()
        starLayer.path = createStarPath(size: CGSize(width: size.width, height: size.height))
        starLayer.lineWidth = lineWidth
        starLayer.strokeColor = strokeColor.cgColor
        starLayer.fillColor = fillColor.cgColor
        starLayer.fillRule = kCAFillRuleNonZero
        
        layer.addSublayer(starLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createStarPath(size: CGSize) -> CGPath {
        let numberOfPoints: CGFloat = 5
        
        let starRatio: CGFloat = 0.5
        
        let steps: CGFloat = numberOfPoints * 2
        
        let outerRadius: CGFloat = min(size.height, size.width) / 2
        let innerRadius: CGFloat = outerRadius * starRatio
        
        let stepAngle = CGFloat(2) * CGFloat(Double.pi) / CGFloat(steps)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let path = CGMutablePath()
        
        for i in 0..<Int(steps) {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            
            let angle = CGFloat(i) * stepAngle - CGFloat(Double.pi/2)
            
            let x = radius * cos(angle) + center.x
            let y = radius * sin(angle) + center.y
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            }
            else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}
