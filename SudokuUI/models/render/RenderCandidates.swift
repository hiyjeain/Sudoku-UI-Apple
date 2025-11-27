//
//  RenderCandidates.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit
import Combine

public class RenderCandidates: RenderNode, Equatable, ObservableObject {
    public static func == (lhs: RenderCandidates, rhs: RenderCandidates) -> Bool {
        lhs.renderCandidates == rhs.renderCandidates
    }
    
    func onInterceptAction(_ action: RenderAction) -> Bool {
        true
    }
    
    public var renderCandidates: [RenderCandidate]
    
    init(renderCandidates: [RenderCandidate] = [
        RenderCandidate(candidate: 1),
        RenderCandidate(candidate: 2),
        RenderCandidate(candidate: 3),
        RenderCandidate(candidate: 4),
        RenderCandidate(candidate: 5),
        RenderCandidate(candidate: 6),
        RenderCandidate(candidate: 7),
        RenderCandidate(candidate: 8),
        RenderCandidate(candidate: 9),
    ]) {
        self.renderCandidates = renderCandidates
    }
    
    func reset() {
        for var child in self.getChildNodes() {
            child.reset()
        }
    }
    
    func getChildNodes() -> [any RenderNode] {
        self.renderCandidates
    }
    
    func onAction(_ action: RenderAction) -> Bool {
        return false
    }
}
