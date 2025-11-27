//
//  SudokuGridView.swift
//  Sudoku
//
//  Created by Garrett Xu on 3/4/25.
//

import os
import SwiftUI
import RSudokuKit
import Combine

class PlayGame: ObservableObject {
    @Published var selectedIndex: (any AsIndex)? = nil
}

public class PlaySudokuConfiguration: ObservableObject {
    @Published var size: CGFloat {
        didSet {
//            AppLog.ui.trace("Setting size: \(size)")
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

public struct PlaySudokuView: View {
    let padding = 16.0
    public var sudoku: RenderSudoku
    @ObservedObject public var game: SudokuGame
    @StateObject public var configuration = PlaySudokuConfiguration()
    @FocusState private var focused: Bool
    
    public init(sudoku: RenderSudoku, game: SudokuGame) {
        self.sudoku = sudoku
        self.game = game
    }
    
    public var body: some View {
//        let _ = AppLog.ui.trace("PlaySudokuView: Rerendering")
        GeometryReader { geometry in
            ZStack {
                HStack {
                    rowHeaderView
                    VStack {
                        columnHeaderView
                        cellsGridView
                    }
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .background(
                Color.clear.contentShape(Rectangle())
            )
            .onAppear {
                self.configuration.size = min(geometry.size.width, geometry.size.height)
            }
            .onChange(of: geometry.size) { oldSize, newSize in
                self.configuration.size = min(newSize.width, newSize.height)
            }
        }
        .focusable()
        .focused($focused)
        .focusEffectDisabled()
    }
    private var rowHeaderView: some View {
        VStack(spacing: 0) {
//            let _ = AppLog.ui.trace("PlaySudokuView.rowHeaderView: Rerendering")
            ForEach(0..<10, id: \.self) { headerRow in
                if headerRow > 0 {
                    Text("\(headerRow)")
                        .frame(width: configuration.cellSize, height: configuration.cellSize)
                        .foregroundColor(.text1)
                        .font(.system(size: configuration.cellFontSize / 2.0))
                } else {
                    Rectangle()
                        .fill(Color.white.opacity(0.0))
                        .frame(width: configuration.cellSize, height: configuration.cellSize)
                }
            }
        }
    }
    
    private var columnHeaderView: some View {
        HStack(spacing: 0) {
//            let _ = AppLog.ui.trace("PlaySudokuView.columnHeaderView: Rerendering")
            ForEach(0..<9, id: \.self) { headerColumn in
                Text("\(UnicodeScalar(headerColumn + 65)!)")
                    .frame(width: configuration.cellSize, height: configuration.cellSize)
                    .foregroundColor(Color.cellBorder)
                    .font(.system(size: configuration.cellFontSize / 2.0))
            }
        }
    }
    
    private var cellsGridView: some View {
        VStack(spacing: 0) {
//            let _ = AppLog.ui.trace("PlaySudokuView.cellsGridView: Rerendering")
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        let index = row * 9 + col
                        if let cell = sudoku.getCell(index: index) {
                            PlayCellView(cell: cell, size: configuration.cellSize)
                                .frame(width: configuration.cellSize, height: configuration.cellSize)
                                .border(Color.text1, width: configuration.line_width)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    game.select(index: index)
                                    focused = true
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func getBorderWidth(row: Int, col: Int) -> CGFloat {
        var width: CGFloat = 0.5
        
        if col % 3 == 0 {
            width = 1.5 // Left border
        }
        if col == 8 {
            width = 1.5 // Right border
        }
        if row % 3 == 0 {
            width = max(width, 1.5) // Top border
        }
        if row == 8 {
            width = max(width, 1.5) // Bottom border
        }
        
        return width
    }
}

#Preview("Empty") {
    PlaySudokuView(sudoku: RenderSudoku(), game: SudokuGame())
}

#Preview("Full") {
    PlaySudokuView(sudoku: RenderSudoku(
        renderCells: [
            RenderCell(index: 0, renderCandidates: RenderCandidates(renderCandidates: [
                RenderCandidate(candidate: 1, isShown: true),
                RenderCandidate(candidate: 2),
                RenderCandidate(candidate: 3),
                RenderCandidate(candidate: 4),
                RenderCandidate(candidate: 5),
                RenderCandidate(candidate: 6, isShown: true),
                RenderCandidate(candidate: 7),
                RenderCandidate(candidate: 8),
                RenderCandidate(candidate: 9),
            ])),
            RenderCell(index: 1, clue: 2),
            RenderCell(index: 2, value: 3),
            RenderCell(index: 3, value: 4),
            RenderCell(index: 4, value: 5),
            RenderCell(index: 5, renderCandidates: RenderCandidates(renderCandidates: [
                RenderCandidate(candidate: 1, isShown: true, highlightColor: Color.candidateCellInfo1),
                RenderCandidate(candidate: 2),
                RenderCandidate(candidate: 3),
                RenderCandidate(candidate: 4),
                RenderCandidate(candidate: 5),
                RenderCandidate(candidate: 6, isShown: true),
                RenderCandidate(candidate: 7),
                RenderCandidate(candidate: 8),
                RenderCandidate(candidate: 9),
            ])),
            RenderCell(index: 6, clue: 7),
            RenderCell(index: 7, value: 8),
            RenderCell(index: 8, value: 9),
            
            RenderCell(index: 9, clue: 5),
            RenderCell(index: 10, clue: 9),
            RenderCell(index: 11),
            RenderCell(index: 12),
            RenderCell(index: 13, clue: 8),
            RenderCell(index: 14),
            RenderCell(index: 15),
            RenderCell(index: 16),
            RenderCell(index: 17),
        RenderCell(index: 18),  RenderCell(index: 19),  RenderCell(index: 20),  RenderCell(index: 21),  RenderCell(index: 22),  RenderCell(index: 23),  RenderCell(index: 24),  RenderCell(index: 25),  RenderCell(index: 26),
        RenderCell(index: 27),  RenderCell(index: 28),  RenderCell(index: 29),  RenderCell(index: 30),  RenderCell(index: 31),  RenderCell(index: 32),  RenderCell(index: 33),  RenderCell(index: 34),  RenderCell(index: 35),
        RenderCell(index: 36),  RenderCell(index: 37),  RenderCell(index: 38),  RenderCell(index: 39),  RenderCell(index: 40),  RenderCell(index: 41),  RenderCell(index: 42),  RenderCell(index: 43),  RenderCell(index: 44),
        RenderCell(index: 45),  RenderCell(index: 46),  RenderCell(index: 47),  RenderCell(index: 48),  RenderCell(index: 49),  RenderCell(index: 50),  RenderCell(index: 51),  RenderCell(index: 52),  RenderCell(index: 53),
        RenderCell(index: 54),  RenderCell(index: 55),  RenderCell(index: 56),  RenderCell(index: 57),  RenderCell(index: 58),  RenderCell(index: 59),  RenderCell(index: 60),  RenderCell(index: 61),  RenderCell(index: 62),
        RenderCell(index: 63),  RenderCell(index: 64),  RenderCell(index: 65),  RenderCell(index: 66),  RenderCell(index: 67),  RenderCell(index: 68),  RenderCell(index: 69),  RenderCell(index: 70),  RenderCell(index: 71),
        RenderCell(index: 72),  RenderCell(index: 73),  RenderCell(index: 74),  RenderCell(index: 75),  RenderCell(index: 76),  RenderCell(index: 77),  RenderCell(index: 78),  RenderCell(index: 79),  RenderCell(index: 80)
    ]
    ), game: SudokuGame())
}
