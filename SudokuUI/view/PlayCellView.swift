//
//  CellView.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 2/27/25.
//


import SwiftUI
import os
import RSudokuKit

struct PlayCellView: View {
    @Bindable var cell: RenderCell
    let size: CGFloat
    var row: UInt8 { UInt8(cell.index.asIndex().value() / 9) }
    var col: UInt8 { UInt8(cell.index.asIndex().value() % 9) }

    var body: some View {
//        let _ = print("PlayCellView: Rerendering")
        ZStack {
//            let _ = print("PlayCellView: Rerending \(cell.index)")
            if let highlightColor = cell.highlightColor {
                Rectangle().fill(highlightColor)
            }
            if let clue = cell.clue {
                Text("\(clue)")
                    .foregroundColor(cell.clueTextColor)
                    .font(.system(size: size * 0.618))
                    .fontWeight(.bold)
                
            } else if let value = cell.value {
                Text("\(value)")
                    .foregroundColor(cell.valueTextColor)
                    .font(.system(size: size * 0.618))
                    .fontWeight(.bold)
            } else {
                PlayCandidatesView(candidates: cell.renderCandidates, size: size)
            }
            if let maskColor = cell.maskColor {
                Rectangle().fill(maskColor)
            }
        }
        .frame(width: size, height: size)
        .overlay(borderOverlay)
    }

    var borderOverlay: some View {
        GeometryReader { geometry in
            let selectedWidth: CGFloat = 6;
            let width = geometry.size.width
            let height = geometry.size.height

            let topWidth: CGFloat = (row % 3 == 0) ? 2 : 0.5
            let bottomWidth: CGFloat = (row == 8) ? 2 : 0.5
            let leftWidth: CGFloat = (col % 3 == 0) ? 2 : 0.5
            let rightWidth: CGFloat = (col == 8) ? 2 : 0.5

            ZStack {
                // Top border
                Rectangle()
                    .frame(height: topWidth)
                    .foregroundColor(.text1)
                    .position(x: width / 2, y: topWidth / 2)
                // Bottom border
                Rectangle()
                    .frame(height: bottomWidth)
                    .foregroundColor(.text1)
                    .position(x: width / 2, y: height - bottomWidth / 2)
                // Left border
                Rectangle()
                    .frame(width: leftWidth)
                    .foregroundColor(.text1)
                    .position(x: leftWidth / 2, y: height / 2)
                // Right border
                Rectangle()
                    .frame(width: rightWidth)
                    .foregroundColor(.text1)
                    .position(x: width - rightWidth / 2, y: height / 2)
                
                if cell.isSelected {
                    // Top border
                    Rectangle()
                        .frame(width: width - leftWidth - rightWidth, height: selectedWidth)
                        .foregroundColor(.accentColor)
                        .position(x: (width + leftWidth - rightWidth) / 2, y: topWidth + selectedWidth / 2)
                    // Bottom border
                    Rectangle()
                        .frame(width: width - leftWidth - rightWidth, height: selectedWidth)
                        .foregroundColor(.accentColor)
                        .position(x: (width + leftWidth - rightWidth) / 2, y: height - bottomWidth - selectedWidth / 2)
                    // Left border
                    Rectangle()
                        .frame(width: selectedWidth, height: height - topWidth - bottomWidth)
                        .foregroundColor(.accentColor)
                        .position(x: leftWidth + selectedWidth / 2, y: (height + topWidth - bottomWidth) / 2)
                    // Right border
                    Rectangle()
                        .frame(width: selectedWidth, height: height - topWidth - bottomWidth)
                        .foregroundColor(.accentColor)
                        .position(x: width - rightWidth - selectedWidth / 2, y: (height + topWidth - bottomWidth) / 2)

                }
            }
        }
        .clipped()
    }
}

#Preview("Empty") {
    PlayCellView(
        cell: RenderCell(index: 0),
        size: 100)
}

#Preview("Clued") {
    PlayCellView(
        cell: RenderCell(index: 0, clue: 1),
        size: 100)
}

#Preview("Valued") {
    PlayCellView(
        cell: RenderCell(index: 0, value: 1),
        size: 100)
}

#Preview("Selected") {
    PlayCellView(
        cell: RenderCell(index: 0, value: 1, isSelected: true),
        size: 100)
}

#Preview("Candidated") {
    PlayCellView(
        cell: RenderCell(
            index: 0,
            renderCandidates: RenderCandidates(renderCandidates: [
                RenderCandidate(candidate: 1, ),
                RenderCandidate(candidate: 2, isShown: true, highlightColor: Color.candidateCellInfo1),
                RenderCandidate(candidate: 3, isShown: true),
                RenderCandidate(candidate: 4, ),
                RenderCandidate(candidate: 5, ),
                RenderCandidate(candidate: 6, isShown: true),
                RenderCandidate(candidate: 7, ),
                RenderCandidate(candidate: 8, ),
                RenderCandidate(candidate: 9, isShown: true),
            ])),
        size: 100)
}
