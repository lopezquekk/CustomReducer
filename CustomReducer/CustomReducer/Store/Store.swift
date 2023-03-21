//
//  Store.swift
//  CustomReducer
//
//  Created by Juan Camilo López Gallego on 16/03/23.
//

import Foundation
import SwiftUI
import Combine

@dynamicMemberLookup
final class Store<R: Reducer>: ObservableObject {
    var reducer: R = R.init()
    private(set) lazy var objectWillChange = ObservableObjectPublisher()
    private var provisionalState: R.State
    var state: R.State {
        didSet {
            if state != oldValue {
                objectWillChange.send()
            }
        }
    }
    subscript<T>(dynamicMember keyPath: WritableKeyPath<R.State, T>) -> T {
        get { state[keyPath: keyPath] }
        set { state[keyPath: keyPath] = newValue }
    }

    init(initialState: R.State) {
        self.state = initialState
        self.provisionalState = state
    }
    
    func binding<T>(_ keyPath: WritableKeyPath<R.State, T>) -> Binding<T> {
        Binding {
            self.provisionalState[keyPath: keyPath]
        } set: {
            self.provisionalState[keyPath: keyPath] = $0
            self.state = self.provisionalState
        }

    }
    
    @MainActor
    func send(_ action: R.Action) {
        let operation = reducer.reduce(into: &provisionalState, action)
        state = provisionalState
        resolveOperation(operation)
    }
    
    @MainActor
    private func resolveOperation(_ operation: Operation<R.Action>) {
        switch operation {
        case .none:
            break
        case let .task(nextAction):
            Task {
                await send(nextAction())
            }
        case let .run(toExecute):
            Task {
                await toExecute()
            }
        case let .action(act):
            send(act)
        case let .merge(act1, act2):
            resolveOperation(act1)
            resolveOperation(act2)
        }
    }
}

protocol Reducer<State, Action> {
    associatedtype Action
    associatedtype State: Equatable
    
    init()
    
    @MainActor func reduce(into state: inout State, _ action: Action) -> Operation<Action>
}

indirect enum Operation<Action> {
    case merge(Operation<Action>, Operation<Action>)
    case task(() async -> Action)
    case run(() async -> Void)
    case action(Action)
    case none
}
