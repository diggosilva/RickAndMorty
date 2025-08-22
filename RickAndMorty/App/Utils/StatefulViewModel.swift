//
//  StatefulViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 21/08/25.
//

import Combine

protocol StatefulViewModel {
    associatedtype State
    var statePublisher: AnyPublisher<State, Never> { get }
}
