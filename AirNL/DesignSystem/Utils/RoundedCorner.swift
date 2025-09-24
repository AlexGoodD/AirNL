//
//  RoundedCorner.swift
//  AirNL
//
//  Created by Alejandro on 24/09/25.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: [Corner]
    
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = corners.contains(.topLeft) ? radius : 0
        let tr = corners.contains(.topRight) ? radius : 0
        let bl = corners.contains(.bottomLeft) ? radius : 0
        let br = corners.contains(.bottomRight) ? radius : 0
        
        // top-left start
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        
        // top-right corner
        if tr > 0 {
            path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
                        radius: tr,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(0),
                        clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        
        // bottom-right
        if br > 0 {
            path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br),
                        radius: br,
                        startAngle: .degrees(0),
                        endAngle: .degrees(90),
                        clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        
        // bottom-left
        if bl > 0 {
            path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl),
                        radius: bl,
                        startAngle: .degrees(90),
                        endAngle: .degrees(180),
                        clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        
        // top-left
        if tl > 0 {
            path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl),
                        radius: tl,
                        startAngle: .degrees(180),
                        endAngle: .degrees(270),
                        clockwise: false)
        }
        
        return path
    }
}
