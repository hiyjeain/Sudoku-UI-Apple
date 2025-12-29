//
//  RenderCandidate.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit

@Observable public class RenderCandidate: RenderNode/*, Equatable*/ {
//    public static func == (lhs: RenderCandidate, rhs: RenderCandidate) -> Bool {
//        return lhs.candidate == rhs.candidate &&
//        lhs.isShown == rhs.isShown &&
//        lhs.candidateTextColor == rhs.candidateTextColor &&
//        lhs.highlightColor == rhs.highlightColor &&
//        lhs.maskColor == rhs.maskColor &&
//        lhs.candidateCellBorderColor == rhs.candidateCellBorderColor
//    }
    
    
    public var candidate: UInt8
    public var isShown: Bool = false
    public var candidateTextColor: Color
    public var highlightColor: Color?
    public var maskColor: Color?
    public var candidateCellBorderColor: Color
    
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
    
    func reset() {
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
        case .RenderCandidateOfCell(_, _):
            self.isShown = true
            return true
        case .RenderCandidatesOfCell(_, _):
            self.isShown = true
            return false
        case .RenderCandidateOfCellBackground(_, _, let color):
            self.highlightColor = RenderColorParser.parseColor(color)
            return true
        case .RenderCandidatesOfCellBackground(_, _, let color):
            self.highlightColor = RenderColorParser.parseColor(color)
            return false
        case .RenderCandidateOfCellMask(_, _, let color):
            self.maskColor = RenderColorParser.parseColor(color)
            return true
        case .RenderCandidatesOfCellMask(_, _, let color):
            self.maskColor = RenderColorParser.parseColor(color)
            return false
        case .Init:
            self.reset()
            return false
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
        case .Init:
            return true
        default:
            return false
        }
    }
}
