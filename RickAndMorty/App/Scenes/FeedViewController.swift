//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    let viewModel: any FeedViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any FeedViewModelProtocol = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.fetchCharacters()
        handleStates()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                    
                case .loading:
                    return showLoadingState()
                case .loaded:
                    return showLoadedState()
                case .error:
                    return showErrorState()
                }
            }.store(in: &cancellables)
        
    }
    
    private func showLoadingState() {
        print("DEBUG: Loading...")
    }
    
    private func showLoadedState() {
        print("DEBUG: Loaded!!!")
    }
    
    private func showErrorState() {
        print("DEBUG: ERROR..")
    }
}
