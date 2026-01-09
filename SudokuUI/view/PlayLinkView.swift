//
//  PlayLinkView.swift
//  SudokuDevHelper
//
//  Created by Codex on 10/11/25.
//

import SwiftUI

struct PlayLinkView: View {
    let link: RenderLink
    let start: CGPoint
    let end: CGPoint
    let candidateRadius: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        Canvas { context, _ in
            let direction = CGVector(dx: end.x - start.x, dy: end.y - start.y)
            let length = hypot(direction.dx, direction.dy)
            guard length > 0.1 else { return }
            let unit = CGVector(dx: direction.dx / length, dy: direction.dy / length)
            let trimmedLength = max(0, length - candidateRadius - candidateRadius)
            let trimmedEnd = CGPoint(
                x: start.x + unit.dx * (candidateRadius + trimmedLength),
                y: start.y + unit.dy * (candidateRadius + trimmedLength)
            )
            let trimmedStart = CGPoint(
                x: start.x + unit.dx * candidateRadius,
                y: start.y + unit.dy * candidateRadius
            )
            let arrowLength = link.isDirected ? lineWidth * 4.0 : 0.0
            let lineEnd = CGPoint(
                x: trimmedEnd.x - unit.dx * arrowLength,
                y: trimmedEnd.y - unit.dy * arrowLength
            )
            var path = Path()
            path.move(to: trimmedStart)
            path.addLine(to: lineEnd)
            let strokeStyle = StrokeStyle(
                lineWidth: lineWidth,
                lineCap: .round,
                lineJoin: .round,
                dash: link.isDashed ? [lineWidth * 2.5, lineWidth * 1.5] : []
            )
            context.stroke(path, with: .color(link.color), style: strokeStyle)

            if link.isDirected {
                let arrowWidth = lineWidth * 2.2
                let base = CGPoint(x: trimmedEnd.x - unit.dx * arrowLength, y: trimmedEnd.y - unit.dy * arrowLength)
                let perp = CGVector(dx: -unit.dy, dy: unit.dx)
                let left = CGPoint(x: base.x + perp.dx * arrowWidth, y: base.y + perp.dy * arrowWidth)
                let right = CGPoint(x: base.x - perp.dx * arrowWidth, y: base.y - perp.dy * arrowWidth)
                var arrowPath = Path()
                arrowPath.move(to: trimmedEnd)
                arrowPath.addLine(to: left)
                arrowPath.addLine(to: right)
                arrowPath.addLine(to: trimmedEnd)
                context.fill(arrowPath, with: .color(link.color))
            }
        }
    }
}
