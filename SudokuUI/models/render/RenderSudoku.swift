//
//  RenderSudoku.swift
//  SudokuDevHelper
//
//  Created by 徐珺�? on 5/27/25.
//

import RSudokuKit
import SwiftUI

@Observable public class RenderSudoku: RenderNode {
    
    public var renderCells: [RenderCell] = [
        RenderCell(index: 0),   RenderCell(index: 1),   RenderCell(index: 2),   RenderCell(index: 3),   RenderCell(index: 4),   RenderCell(index: 5),   RenderCell(index: 6),   RenderCell(index: 7),   RenderCell(index: 8),
        RenderCell(index: 9),   RenderCell(index: 10),  RenderCell(index: 11),  RenderCell(index: 12),  RenderCell(index: 13),  RenderCell(index: 14),  RenderCell(index: 15),  RenderCell(index: 16),  RenderCell(index: 17),
        RenderCell(index: 18),  RenderCell(index: 19),  RenderCell(index: 20),  RenderCell(index: 21),  RenderCell(index: 22),  RenderCell(index: 23),  RenderCell(index: 24),  RenderCell(index: 25),  RenderCell(index: 26),
        RenderCell(index: 27),  RenderCell(index: 28),  RenderCell(index: 29),  RenderCell(index: 30),  RenderCell(index: 31),  RenderCell(index: 32),  RenderCell(index: 33),  RenderCell(index: 34),  RenderCell(index: 35),
        RenderCell(index: 36),  RenderCell(index: 37),  RenderCell(index: 38),  RenderCell(index: 39),  RenderCell(index: 40),  RenderCell(index: 41),  RenderCell(index: 42),  RenderCell(index: 43),  RenderCell(index: 44),
        RenderCell(index: 45),  RenderCell(index: 46),  RenderCell(index: 47),  RenderCell(index: 48),  RenderCell(index: 49),  RenderCell(index: 50),  RenderCell(index: 51),  RenderCell(index: 52),  RenderCell(index: 53),
        RenderCell(index: 54),  RenderCell(index: 55),  RenderCell(index: 56),  RenderCell(index: 57),  RenderCell(index: 58),  RenderCell(index: 59),  RenderCell(index: 60),  RenderCell(index: 61),  RenderCell(index: 62),
        RenderCell(index: 63),  RenderCell(index: 64),  RenderCell(index: 65),  RenderCell(index: 66),  RenderCell(index: 67),  RenderCell(index: 68),  RenderCell(index: 69),  RenderCell(index: 70),  RenderCell(index: 71),
        RenderCell(index: 72),  RenderCell(index: 73),  RenderCell(index: 74),  RenderCell(index: 75),  RenderCell(index: 76),  RenderCell(index: 77),  RenderCell(index: 78),  RenderCell(index: 79),  RenderCell(index: 80)
    ]
    
    init() {}
    
    init(renderCells: [RenderCell]) {
        self.renderCells = renderCells
    }
    
    func reset() {
        for child in renderCells {
            child.reset()
        }
    }
    
    func getChildNodes() -> [any RenderNode] {
        return renderCells
    }
    
    func onAction(_ action: RenderAction) -> Bool {
        return false
    }
    
    func onInterceptAction(_ action: RenderAction) -> Bool {
        return true
    }
    
    func getCell(index: Int) -> RenderCell? {
        guard index >= 0 && index < renderCells.count else {
            return nil
        }
        return renderCells[index]
    }
}
