//
//  RenderCell.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import Combine
import RSudokuKit

public class RenderCell: RenderNode, ObservableObject, Equatable {
    public static func == (lhs: RenderCell, rhs: RenderCell) -> Bool {
        return lhs.index == rhs.index &&
        lhs.clue == rhs.clue &&
        lhs.value == rhs.value &&
        lhs.isSelected == rhs.isSelected &&
        lhs.renderCandidates == rhs.renderCandidates &&
        lhs.clueTextColor == rhs.clueTextColor &&
        lhs.valueTextColor == rhs.valueTextColor &&
        lhs.highlightColor == rhs.highlightColor &&
        lhs.maskColor == rhs.maskColor
    }
    
    
    public let index: Index
    @Published public var clue: Clue? = nil
    @Published public var value: Value? = nil
    @Published public var isSelected: Bool = false
    public var renderCandidates: RenderCandidates = RenderCandidates()
    @Published public var clueTextColor: Color = Color.textClue
    @Published public var valueTextColor: Color = Color.textValue
    @Published public var highlightColor: Color? = nil
    @Published public var maskColor: Color? = nil
    
    init(index: any AsIndex) {
        self.index = index.asIndex()
    }
    
    init(index: any AsIndex,
         clue: (any AsClue)? = nil,
         value: (any AsValue)? = nil,
         isSelected: Bool = false,
         renderCandidates: RenderCandidates = RenderCandidates()) {
        self.index = index.asIndex()
        self.clue = clue?.asClue()
        self.renderCandidates = renderCandidates
        self.isSelected = isSelected
    }
    
    func reset() {
        self.clue               = nil
        self.value              = nil
        self.highlightColor     = nil
        self.maskColor          = nil
        self.clueTextColor      = Color.textClue
        self.valueTextColor     = Color.textValue
        self.isSelected         = false
        self.renderCandidates.reset()
    }
    
    func getChildNodes() -> [any RenderNode] {
        return [renderCandidates]
    }
    
    func onAction(_ action: RenderAction) -> Bool {
        switch action {
        case .RenderClue(_, let clue):
            assignIfChanged(&self.clue, clue.asClue())
            return true
        case .RenderValue(_, let value):
            assignIfChanged(&self.value, value.asValue())
            return true
        case .RenderPutValue(_, let value):
            assignIfChanged(&self.value, value.asValue())
            self.valueTextColor = Color.textValuePositive
            return true
        case .RenderCellBackground(_, let color):
            assignIfChanged(&self.highlightColor, RenderColorParser.parseColor(color))
            return true
        case .RenderCellMask(_, let color):
            assignIfChanged(&self.maskColor, RenderColorParser.parseColor(color))
            return true
        case .RenderHighlightValueColor(_, let color):
            assignIfChanged(&self.valueTextColor, RenderColorParser.parseColor(color) ?? self.valueTextColor)
            return true
        case .RenderMaskColor(_, let color):
            assignIfChanged(&self.maskColor, RenderColorParser.parseColor(color))
            return true
        case .RenderSelected(_):
            assignIfChanged(&self.isSelected, true)
            return true
        case .RenderUnselected(_):
            assignIfChanged(&self.isSelected, false)
            return true
        default:
            return false
        }
    }
    
    
    func onInterceptAction(_ action: RenderAction) -> Bool {
        switch action {
        case .RenderClue(let idx, _),
             .RenderValue(let idx, _),
             .RenderPutValue(let idx, _),
             .HideCandidateOfCell(let idx, _),
             .HideCandidatesOfCell(let idx, _),
             .ShowCandidateOfCell(let idx, _),
             .ShowCandidatesOfCell(let idx, _),
             .RenderCandidateOfCell(let idx, _),
             .RenderCandidatesOfCell(let idx, _),
             .RenderCellBackground(let idx, _),
             .RenderCellMask(let idx, _),
             .RenderHighlightValueColor(let idx, _),
             .RenderMaskColor(let idx, _),
             .RenderCandidateOfCellBackground(let idx, _, _),
             .RenderCandidateOfCellMask(let idx, _, _),
             .RenderCandidatesOfCellBackground(let idx, _, _),
             .RenderSelected(let idx),
             .RenderUnselected(let idx),
             .RenderCandidatesOfCellMask(let idx, _, _):
            return idx.asIndex() == self.index
        default:
            return true
        }
    }
}
