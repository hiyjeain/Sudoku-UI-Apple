//
//  RenderLinks.swift
//  SudokuDevHelper
//
//  Created by Codex on 10/11/25.
//

import SwiftUI
import RSudokuKit

@Observable public class RenderLinks: RenderNode {
    public var renderLinks: [RenderLink] = []

    func reset() {
        renderLinks.removeAll()
    }

    func getChildNodes() -> [any RenderNode] {
        return renderLinks
    }

    func onAction(_ action: RenderAction) -> Bool {
        switch action {
        case .Init:
            renderLinks.removeAll()
            return false
        case .RenderChain(let fromIndex, let toIndex, let candidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(candidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: false,
                isDirected: false
            )
            renderLinks.append(link)
            return true
        case .RenderDashChain(let fromIndex, let toIndex, let candidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(candidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: true,
                isDirected: false
            )
            renderLinks.append(link)
            return true
        case .RenderLink(let fromIndex, let toIndex, let candidate, let alternateCandidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(alternateCandidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: false,
                isDirected: true
            )
            renderLinks.append(link)
            return true
        case .RenderDashLink(let fromIndex, let toIndex, let candidate, let alternateCandidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(alternateCandidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: true,
                isDirected: true
            )
            renderLinks.append(link)
            return true
        case .RenderUndirectedLink(let fromIndex, let toIndex, let candidate, let alternateCandidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(alternateCandidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: false,
                isDirected: false
            )
            renderLinks.append(link)
            return true
        case .RenderUndirectedDashLink(let fromIndex, let toIndex, let candidate, let alternateCandidate, let color):
            let link = RenderLink(
                fromIndex: fromIndex.asIndex(),
                toIndex: toIndex.asIndex(),
                fromCandidate: UInt8(candidate.asCandidate().value()),
                toCandidate: UInt8(alternateCandidate.asCandidate().value()),
                color: RenderColorParser.parseColor(color) ?? .text1,
                isDashed: true,
                isDirected: false
            )
            renderLinks.append(link)
            return true
        default:
            return false
        }
    }

    func onInterceptAction(_ action: RenderAction) -> Bool {
        return true
    }
}
