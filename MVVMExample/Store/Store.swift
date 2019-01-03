//
//  Store.swift
//  MVVMExample
//
//  Created by Wang Kai on 2018/2/26.
//  Copyright © 2018年 Pirate. All rights reserved.
//

import Foundation

class Store<A: ActionType, S: StateType, C: CommandType> {
    let reducer: (_ state: S, _ action: A) -> (S, C?)
    var subscriber: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    var state: S

    init(reducer: @escaping (S, A) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }

    func dispatch(_ action: A) {
        let previousState = state
        let (nextState, command) = reducer(state, action)
        state = nextState
        subscriber?(state, previousState, command)
    }

    func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscriber = handler
    }

    func unsubscribe() {
        self.subscriber = nil
    }
}
