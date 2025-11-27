//
//  RenderColor.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit

class RenderColorParser {
    static func parseColor(_ color: AsRenderColor) -> Color? {
        let color = color.asRenderColor()
        switch color {
        case .None:
            return nil
        case .TextClue:
            return Color.textClue
        case .TextValue:
            return Color.textValue
        case .TextValuePositive:
            return Color.textValuePositive
        case .TextValueNegative:
            return Color.textValueNegative
        case .TextValueInvalid:
            return Color.textValueInvalid
        case .TextClueOrValueNegative:
            return Color.textClueOrValueNegative
        case .TextCandidate:
            return Color.textCandidate
        case .TextCandidateAdded:
            return Color.textCandidateAdded
        case .TextCandidateRemoved:
            return Color.textCandidateRemoved
        case .CellMask:
            return Color.cellMask
        case .CellPositive:
            return Color.cellPositive
        case .CellNegative:
            return Color.cellNegative
        case .CellInfo1:
            return Color.cellInfo1
        case .CellInfo2:
            return Color.cellInfo2
        case .CellInfo3:
            return Color.cellInfo3
        case .CellInfo4:
            return Color.cellInfo4
        case .CandidateCellPositive:
            return Color.candidateCellPositive
        case .CandidateCellNegative:
            return Color.candidateCellNegative
        case .CandidateCellInfo1:
            return Color.candidateCellInfo1
        case .CandidateCellInfo2:
            return Color.candidateCellInfo2
        case .CandidateCellInfo3:
            return Color.candidateCellInfo3
        case .CandidateCellInfo4:
            return Color.candidateCellInfo4
        case .CandidateCellBorderPositive:
            return Color.candidateCellBorderPositive
        case .CandidateCellBorderNegative:
            return Color.candidateCellBorderNegative
        case .CandidateCellBorderInfo1:
            return Color.candidateCellBorderInfo1
        case .CandidateCellBorderInfo2:
            return Color.candidateCellBorderInfo2
        case .CandidateCellBorderInfo3:
            return Color.candidateCellBorderInfo3
        case .CandidateCellBorderInfo4:
            return Color.candidateCellBorderInfo4
        default:
            return nil
        }
    }
}
