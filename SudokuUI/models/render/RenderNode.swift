//
//  RenderNode.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import RSudokuKit

protocol RenderNode: AnyObject {
    func getChildNodes() -> [any RenderNode]
    func reset()
    func onAction(_ action: RenderAction) -> Bool
    func onInterceptAction(_ action: RenderAction) -> Bool
}

extension RenderNode {
    func dispatchAction(_ action: RenderAction) -> Bool {
        if onInterceptAction(action) {
            let consumed = self.onAction(action)
            if !consumed {
                for child in self.getChildNodes() {
                    if child.dispatchAction(action) {
                        return true;
                    }
                }
            }
            return consumed
        }
        return false
   }
}
