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
    }
    
    public func apply(solutionStep: SolutionStep) {
        self.game.apply(solutionStep: solutionStep)
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
