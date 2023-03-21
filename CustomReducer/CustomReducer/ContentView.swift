//
//  ContentView.swift
//  CustomReducer
//
//  Created by Juan Camilo López Gallego on 16/03/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    struct State {
        var counter: Int = 0
        var title: String = "John"
    }
    
    @Published var state: State = .init()
    
    func updateNumberAndTitle() {
        state.counter = Int.random(in: 0..<100)
        state.counter = Int.random(in: 0..<100)
        state.counter = Int.random(in: 0..<100)
        state.counter = Int.random(in: 0..<100)
        state.counter = Int.random(in: 0..<100)
        state.title = "Camil1"
        state.title = "Camilo"
        state.title = "Camil4"
        state.title = "Camilo"
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                state.counter = Int.random(in: 0..<100)
                state.counter = Int.random(in: 0..<100)
                state.counter = Int.random(in: 0..<100)
                state.counter = Int.random(in: 0..<100)
                state.counter = Int.random(in: 0..<100)
                state.title = "Camil1"
                state.title = "Camilo"
                state.title = "Camil4"
                state.title = "Camilo"
            }
        }
        
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    var body: some View {
        VStack {
            List {
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                Text("\(viewModel.state.counter)")
                
            }
            Button {
                withAnimation(.default.speed(2.0)) {
                    viewModel.updateNumberAndTitle()
                }
                
            } label: {
                Text("Press me")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
