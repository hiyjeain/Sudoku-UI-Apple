//
//  PlayLinksView.swift
//  SudokuDevHelper
//
//  Created by Codex on 10/11/25.
//

import SwiftUI
import RSudokuKit

struct PlayLinksView: View {
    let links: [RenderLink]
    let configuration: PlaySudokuConfiguration

    var body: some View {
        ZStack {
            ForEach(links) { link in
                PlayLinkView(
                    link: link,
                    start: configuration.linkCandidateCenter(for: link.fromIndex, candidate: link.fromCandidate),
                    end: configuration.linkCandidateCenter(for: link.toIndex, candidate: link.toCandidate),
                    candidateRadius: configuration.linkCandidateRadius(),
                    lineWidth: configuration.linkLineWidth()
                )
            }
        }
        .frame(width: configuration.cellSize * 9, height: configuration.cellSize * 9)
        .allowsHitTesting(false)
    }
}

private extension PlaySudokuConfiguration {
    func linkLineWidth() -> CGFloat {
        return max(1, cellSize * 0.035)
    }

    func linkCandidateCenter(for index: Index, candidate: UInt8) -> CGPoint {
        let innerPadding: CGFloat = 8.0
        let candidateSpacing: CGFloat = 1.0
        let row = CGFloat(index.value() / 9)
        let col = CGFloat(index.value() % 9)
        let candidateIndex = max(1, min(9, Int(candidate))) - 1
        let candidateRow = CGFloat(candidateIndex / 3)
        let candidateCol = CGFloat(candidateIndex % 3)
        let candidateSize = linkCandidateSize(innerPadding: innerPadding)
        let cellOrigin = CGPoint(x: col * cellSize, y: row * cellSize)
        let offsetX = innerPadding + (candidateSize + candidateSpacing) * candidateCol + candidateSize / 2.0
        let offsetY = innerPadding + (candidateSize + candidateSpacing) * candidateRow + candidateSize / 2.0
        return CGPoint(x: cellOrigin.x + offsetX, y: cellOrigin.y + offsetY)
    }

    func linkCandidateRadius() -> CGFloat {
        let candidateSize = linkCandidateSize(innerPadding: 8.0)
        return candidateSize * 0.70710678
    }

    private func linkCandidateSize(innerPadding: CGFloat) -> CGFloat {
        return (cellSize - innerPadding - innerPadding) / 3.0
    }
}
