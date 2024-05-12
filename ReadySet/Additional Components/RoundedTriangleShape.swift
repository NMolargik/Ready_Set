//
//  RoundedTriangleShape.swift
//  ReadySet
//
//  Created by Nick Molargik on 4/15/24.
//

import SwiftUI

struct RoundedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let length = min(rect.size.width, rect.size.height)
        let triangleHeight = length * sqrt(3.0) / 2.0
        let xOffset = (rect.size.width - length) / 2
        let yOffset = (rect.size.height - triangleHeight) / 2

        let startPoint = CGPoint(x: rect.midX, y: rect.minY + yOffset)

        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.maxY - yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - xOffset, y: rect.maxY - yOffset))
        path.addLine(to: startPoint)

        return path
    }
}
