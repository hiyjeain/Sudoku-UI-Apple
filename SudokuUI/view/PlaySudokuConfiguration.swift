//
//  PlaySudokuConfiguration.swift
//  SudokuDevHelper
//
//  Created by Codex on 10/11/25.
//

import SwiftUI

@Observable public class PlaySudokuConfiguration {
    var size: CGFloat {
        didSet {
//            AppLog.ui.trace("Setting size: \\(size)")
        }
    }
    var padding: CGFloat
    var puzzle_border_width: CGFloat
    var block_border_width: CGFloat
    var line_width: CGFloat {
        return self.size / (2.0 / 800.0)
    }
    
    var blockSize: CGFloat {
        return (self.size - 2.0 * self.padding) * 3.0 / 10.0
    }
    var cellSize: CGFloat {
        return self.blockSize / 3.0
    }
    
    var cellFontSize: CGFloat {
        return self.cellSize * (2.0 / 3.0)
    }
    
    var paddingInCell: CGFloat {
        return (self.cellSize  - self.cellFontSize) / 2.0
    }
    
    var candidateCellSize: CGFloat {
        return self.cellSize / 3.0 * (4.0 / 5.0)
    }
    
    var candidateFontSize: CGFloat {
        return self.candidateCellSize * (2.0 / 3.0)
    }
    
    init() {
        self.size = 200.0
        self.padding = 20.0
        self.puzzle_border_width = 10
        self.block_border_width = 6
    }
}
