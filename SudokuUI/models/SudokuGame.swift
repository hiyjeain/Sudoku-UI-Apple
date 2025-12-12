//
//  PlayGame.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit

@Observable public class SudokuGame: Renderer.onActionsListener {
    final class SingaleAnswerTask {
        let task: Task<Bool, Error>
        init(task: Task<Bool, Error>) {
            self.task = task
        }
    }
    @ObservationIgnored var checkSingleAnswerTask: SingaleAnswerTask? = nil

    final class NextSolutionStepTask {
        let task: Task<SolutionStep?, Error>
        init(task: Task<SolutionStep?, Error>) {
            self.task = task
        }
    }
    @ObservationIgnored var nextSolutionStepTask: NextSolutionStepTask? = nil
    
    var game: RSudokuGame
    var selectedIndex: (any AsIndex)? = nil
    public var canUndo: Bool = false
    public var canRedo: Bool = false
    public var renderSudoku = RenderSudoku()
    public var isReady = false
    public var nextSolutionStep: SolutionStep? = nil
    private let solver = Solver()
    
    public func checkNextSolutionStep() {
        if !self.isReady {
            nextSolutionStep = nil
            return
        }
        Task {
            await self.getNextSolutionStep()
        }
    }
    
    private func getNextSolutionStep() async {
        self.nextSolutionStep = nil
        self.nextSolutionStepTask?.task.cancel()
        
        let localTask = NextSolutionStepTask(task: Task.detached(priority: .userInitiated) {
            try await self.solver.next(puzzle: self.game.puzzle)
        })
        
        self.nextSolutionStepTask = localTask
        
        guard let result = try? await localTask.task.value else { return }
        guard localTask === self.nextSolutionStepTask else { return }
        self.nextSolutionStep = result
    }

    private func checkIfHasSingleAnswer() async {
        self.isReady = false
        self.checkSingleAnswerTask?.task.cancel()
        
        let localTask = SingaleAnswerTask(task: Task.detached(priority: .userInitiated) {
            try await self.game.puzzle.hasSingleAnswer()
        })
        
        self.checkSingleAnswerTask = localTask
        
        guard let result = try? await localTask.task.value else { return }
        guard localTask === self.checkSingleAnswerTask else { return }
        self.isReady = result
    }
    
    
    public init() {
        self.game = RSudokuGame()
        self.game.renderer.onActionsListener = self
        render()
    }
    
    public func reset() {
        self.game.puzzle.reset()
        self.renderSudoku.reset()
        self.isReady = false
        self.canUndo = false
        self.canRedo = false
    }
    
    public func copy(from: Puzzle) {
        self.reset()
        self.game.puzzle.copy(from: from)
        Task {
            await self.checkIfHasSingleAnswer()
        }
        self.renderSudoku.reset()
        self.render()
    }
    
    public func select(index: any AsIndex) {
        self.game.select(index: index)
        self.selectedIndex = index
    }
    
    public func apply(solutionStep: SolutionStep?, undoManager: UndoManager? = nil) {
        guard let solutionStep = solutionStep else {
            return
        }
        self.game.apply(solutionStep: solutionStep)
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo(undoManager: undoManager)
        }
        undoManager?.setActionName("\(solutionStep.name!)")
        self.nextSolutionStep = nil
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
    }
    
    public func userPut(value: any AsValue, undoManager: UndoManager? = nil) {
        guard let index = self.selectedIndex else { return }
        game.userPut(value: value, at: index)
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo(undoManager: undoManager)
        }
        undoManager?.setActionName("Put value \(value) on \(index)")
        self.nextSolutionStep = nil
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
    }
    
    public func undo(undoManager: UndoManager? = nil) {
        self.game.undo()
        undoManager?.registerUndo(withTarget: self) { target in
            target.redo(undoManager: undoManager)
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = undoManager?.canRedo ?? false
    }
    
    public func redo(undoManager: UndoManager? = nil) {
        self.game.redo()
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo(undoManager: undoManager)
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
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
    }
}
