//
//  PlayGame.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import Combine
import RSudokuKit

public class SudokuGame: ObservableObject, Renderer.onActionsListener {
    var game: RSudokuGame
    public let objectWillChange = ObservableObjectPublisher()
    public var renderSudoku = RenderSudoku()
    
    public init() {
        self.game = RSudokuGame()
        self.game.renderer.onActionsListener = self
        render()
    }
    
    public func select(index: any AsIndex) {
        self.game.select(index: index)
    }
    
    public func render() {
        self.game.render()
    }
    
    public func on(actions: [RenderAction]) {
        if actions.isEmpty {
            return
        }
//        renderSudoku.reset()
        for action in actions {
//            AppLog.viewmodel.trace("SudokuGame: processing \(action)")
            if !renderSudoku.dispatchAction(action) {
//                AppLog.viewmodel.debug("SudokuGame: action \(action) not handled")
            }
        }
        
        objectWillChange.send()
    }
}
