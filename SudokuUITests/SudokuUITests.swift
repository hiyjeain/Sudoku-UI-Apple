//
//  SudokuUITests.swift
//  SudokuUITests
//
//  Created by 徐珺炜 on 11/26/25.
//

import Testing
import RSudokuKit
@testable import SudokuUI

struct SudokuUITests {

    @Test func testPasteHodokuStringReplacesPuzzle() async throws {
        let game = SudokuGame()
        let hodokuString = ":1401:9:..7.4..8..5..+7..39.....6..56...58.....87+6....1.5.2..6.9....7.......3...4...4..3.1:112 212 312 914 832 137 747 748 962 767 172 272 672 872 173 273 673 281 881 682 782 683 184 884 186 291 891 292 792:934::1"

        let didPaste = game.paste(hodokuString: hodokuString)

        #expect(didPaste)
        #expect(game.renderSudoku.getCell(index: 2)?.clue == Clue(7))
    }

    @Test func testPasteRejectsNonHodokuString() async throws {
        let game = SudokuGame()
        let hodokuString = ":1401:9:..7.4..8..5..+7..39.....6..56...58.....87+6....1.5.2..6.9....7.......3...4...4..3.1:112 212 312 914 832 137 747 748 962 767 172 272 672 872 173 273 673 281 881 682 782 683 184 884 186 291 891 292 792:934::1"

        let _ = game.paste(hodokuString: hodokuString)
        let existingClue = game.renderSudoku.getCell(index: 2)?.clue
        let didPaste = game.paste(hodokuString: "not a hodoku string")

        #expect(didPaste == false)
        #expect(game.renderSudoku.getCell(index: 2)?.clue == existingClue)
    }

    @Test func testCopyReturnsHodokuString() async throws {
        let game = SudokuGame()
        let hodokuString = ":1401:9:..7.4..8..5..+7..39.....6..56...58.....87+6....1.5.2..6.9....7.......3...4...4..3.1:112 212 312 914 832 137 747 748 962 767 172 272 672 872 173 273 673 281 881 682 782 683 184 884 186 291 891 292 792:934::1"

        let _ = game.paste(hodokuString: hodokuString)
        let copied = game.copyHodokuString()

        #expect(copied != nil)
        #expect(Puzzle(hodokuString: copied ?? "") != nil)
    }

}
