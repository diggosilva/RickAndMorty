//
//  FeedViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    let viewModel: any FeedViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any FeedViewModelProtocol = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegatesAndDataSources()
        viewModel.fetchCharacters()
        handleStates()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Personagens"
    }
    
    private func setupDelegatesAndDataSources() {
        feedView.collectionView.dataSource = self
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading: return showLoadingState()
                case .loaded: return showLoadedState()
                case .error: return showErrorState()
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        feedView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        feedView.spinner.stopAnimating()
        feedView.collectionView.reloadData()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Ops! Ocorreu um erro!", message: "Tente novamente mais tarde!", buttonTitle: "Ok") {
            self.feedView.spinner.stopAnimating()
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        let char = viewModel.cellForItem(at: indexPath)
        cell.configure(char: char)
        return cell
    }
}
