//
//  RenderLink.swift
//  SudokuDevHelper
//
//  Created by Codex on 10/11/25.
//

import SwiftUI
import RSudokuKit

@Observable public class RenderLink: RenderNode, Identifiable {
    public let id = UUID()
    public let fromIndex: Index
    public let toIndex: Index
    public let fromCandidate: UInt8
    public let toCandidate: UInt8
    public let color: Color
    public let isDashed: Bool
    public let isDirected: Bool

    init(
        fromIndex: Index,
        toIndex: Index,
        fromCandidate: UInt8,
        toCandidate: UInt8,
        color: Color,
        isDashed: Bool,
        isDirected: Bool
    ) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.fromCandidate = fromCandidate
        self.toCandidate = toCandidate
        self.color = color
        self.isDashed = isDashed
        self.isDirected = isDirected
    }

    func reset() {}

    func getChildNodes() -> [any RenderNode] {
        return []
    }

    func onAction(_ action: RenderAction) -> Bool {
        return false
    }

    func onInterceptAction(_ action: RenderAction) -> Bool {
        return true
    }
}
