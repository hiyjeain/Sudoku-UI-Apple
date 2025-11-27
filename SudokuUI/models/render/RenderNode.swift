//
//  RenderNode.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/27/25.
//

import RSudokuKit

protocol RenderNode {
    func getChildNodes() -> [RenderNode];
    mutating func reset();
    mutating func onAction(_ action: RenderAction) -> Bool;
    func onInterceptAction(_ action: RenderAction) -> Bool;
}

extension RenderNode {
    mutating func dispatchAction(_ action: RenderAction) -> Bool {
        if onInterceptAction(action) {
            let consumed = self.onAction(action);
            if !consumed {
                for var child in self.getChildNodes() {
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
