//
//  PlayGame.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import SwiftUI
import RSudokuKit

@Observable public class SudokuGame: Renderer.OnActionsListener {
    final class SingaleAnswerTask {
        let task: Task<Bool, Error>
        init(task: Task<Bool, Error>) {
            self.task = task
        }
    }
    @ObservationIgnored var checkSingleAnswerTask: SingaleAnswerTask? = nil

    final class NextStepTask {
        let task: Task<Step?, Error>
        init(task: Task<Step?, Error>) {
            self.task = task
        }
    }
    @ObservationIgnored var nextStepTask: NextStepTask? = nil
    
    var game: RSudokuGame
    var selectedIndex: (any AsIndex)? = nil
    public var canUndo: Bool = false
    public var canRedo: Bool = false
    public var renderSudoku = RenderSudoku()
    public var isReady = false
    public var nextStep: Step? = nil {
        didSet {
            guard let step = nextStep else {
                DispatchQueue.main.async {
                    self.game.render()
                }
                return
            }
            DispatchQueue.main.async {
                self.game.render(with: step)
            }
        }
    }
    @ObservationIgnored public var undoManager: UndoManager? = nil
    private let solver = Solver()
    
    public func checkNextStep() {
        if !self.isReady {
            nextStep = nil
            return
        }
        Task {
            await self.getNextStep()
        }
    }
    
    public func moveSelection(direction: MovementDirection) -> Bool {
        return self.game.moveSelection(direction: direction)
    }

    private func getNextStep() async {
        self.nextStep = nil
        self.nextStepTask?.task.cancel()
        
        let localTask = NextStepTask(task: Task.detached(priority: .userInitiated) {
            try await self.game.hint()
        })
        
        self.nextStepTask = localTask
        
        guard let result = try? await localTask.task.value else { return }
        guard localTask === self.nextStepTask else { return }
        self.nextStep = result
    }

    private func checkIfHasSingleAnswer() async {
        self.isReady = false
        self.checkSingleAnswerTask?.task.cancel()
        
        let localTask = SingaleAnswerTask(task: Task.detached(priority: .userInitiated) {
            try await self.game.hasSingleAnswer()
        })
        
        self.checkSingleAnswerTask = localTask
        
        guard let result = try? await localTask.task.value else { return }
        guard localTask === self.checkSingleAnswerTask else { return }
        self.isReady = result
    }
    
    
    public init() {
        self.game = RSudokuGame()
        self.game.set(onActionsListener: self)
        render()
    }
    
    public func reset() {
        self.game.reset()
        self.renderSudoku.reset()
        self.isReady = false
        self.canUndo = false
        self.canRedo = false
    }
    
    public func copy(from: Puzzle) {
        self.reset()
        self.game.copy(from: from)
        self.game.reset_history()
        self.game.reset_selection()
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
    
    public func apply(step: Step?) -> Bool{
        guard let step = step else {
            return false
        }
        let result = self.game.apply(step: step)
        if  result {
            undoManager?.registerUndo(withTarget: self) { target in
                target.undo()
            }
            self.nextStep = nil
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
        return result
    }
    
    public func userDelete() -> Bool{
        let result = game.userDelete()
        if result {
            undoManager?.registerUndo(withTarget: self) { target in
                target.undo()
            }
            self.nextStep = nil
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
        return result
    }
    
    public func userInput(number: UInt8, isCandidate: Bool = false) -> Bool{
        let result = game.userInput(number: number, isCandidate: isCandidate)
        if result {
            undoManager?.registerUndo(withTarget: self) { target in
                target.undo()
            }
            self.nextStep = nil
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = game.canRedo()
        return result
    }
    
    public func undo() {
        self.game.undo()
        undoManager?.registerUndo(withTarget: self) { target in
            target.redo()
        }
        self.render()
        self.canUndo = game.canUndo()
        self.canRedo = undoManager?.canRedo ?? false
    }
    
    public func redo() {
        self.game.redo()
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo()
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
