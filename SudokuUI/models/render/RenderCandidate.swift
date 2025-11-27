//
//  RenderCandidate.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit
import Combine

public class RenderCandidate: RenderNode, Equatable, ObservableObject {
    public static func == (lhs: RenderCandidate, rhs: RenderCandidate) -> Bool {
        return lhs.candidate == rhs.candidate &&
        lhs.isShown == rhs.isShown &&
        lhs.candidateTextColor == rhs.candidateTextColor &&
        lhs.highlightColor == rhs.highlightColor &&
        lhs.maskColor == rhs.maskColor &&
        lhs.candidateCellBorderColor == rhs.candidateCellBorderColor
    }
    
    
    @Published public var candidate: UInt8
    @Published public var isShown: Bool = false
    @Published public var candidateTextColor: Color
    @Published public var highlightColor: Color?
    @Published public var maskColor: Color?
    @Published public var candidateCellBorderColor: Color
    
    init(candidate: UInt8,
         isShown: Bool = false,
         candidateTextColor: Color = Color.textCandidate,
         highlightColor: Color? = nil,
         maskColor: Color? = nil,
         candidateCellBorderColor: Color = Color.candidateCellBorder) {
//        AppLog.viewmodel.trace("RenderCandidate: Initing candidate \(candidate)")
        self.candidate = candidate
        self.isShown = isShown
        self.candidateTextColor = candidateTextColor
        self.highlightColor = highlightColor
        self.maskColor = maskColor
        self.candidateCellBorderColor = candidateCellBorderColor
    }
    
    public func reset() {
//        AppLog.viewmodel.trace("RenderCandidate: Resetting candidate \(candidate)")
        self.isShown = false
        self.highlightColor = nil
        self.maskColor = nil
        self.candidateCellBorderColor = Color.candidateCellBorder
        self.candidateTextColor = Color.textCandidate
    }
    
    func getChildNodes() -> [any RenderNode] {
        return []
    }
    
    func onAction(_ action: RenderAction) -> Bool {
        switch action {
        case .RenderCandidateOfCell(_, _),
             .RenderCandidatesOfCell(_, _):
            if assignIfChanged(&isShown, true) {
//                AppLog.viewmodel.trace("RenderCandidate: Candidate \(candidate) is now shown")
            }
            return false
        case .RenderCandidateOfCellBackground(_, _, let color),
             .RenderCandidatesOfCellBackground(_, _, let color):
            if assignIfChanged(&self.highlightColor, RenderColorParser.parseColor(color)) {
//                AppLog.data.trace("RenderCandidate: Updated highlight color for candidate \(candidate) to \(self.highlightColor)")
            }
            return true
        case .RenderCandidateOfCellMask(_, _, let color),
             .RenderCandidatesOfCellMask(_, _, let color):
            if assignIfChanged(&self.maskColor, RenderColorParser.parseColor(color)) {
//                AppLog.data.trace("RenderCandidate: Updated mask color for candidate \(candidate) to \(self.maskColor)")
            }
            return true
        default:
            return false
        }
    }
    
    func onInterceptAction(_ action: RenderAction) -> Bool {
        switch action {
        case .HideCandidateOfCell(_, let candidate),
             .ShowCandidateOfCell(_, let candidate),
             .RenderCandidateOfCell(_, let candidate),
             .RenderCandidateOfCellBackground(_, let candidate, _),
             .RenderCandidateOfCellMask(_, let candidate, _),
             .RenderChain(_, _, let candidate, _),
             .RenderDashChain(_, _, let candidate, _):
            return candidate.asCandidate().value() == self.candidate

        case .HideCandidatesOfCell(_, let candidates),
             .ShowCandidatesOfCell(_, let candidates),
             .RenderCandidatesOfCell(_, let candidates),
             .RenderCandidatesOfCellBackground(_, let candidates, _),
             .RenderCandidatesOfCellMask(_, let candidates, _):
            return candidates.asCandidates().contains(candidate: self.candidate)

        default:
            return false
        }
    }
}
