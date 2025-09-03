//
//  FeedViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private let feedView = FeedView()
    private let viewModel: any FeedViewModelProtocol
    private let searchController = UISearchController(searchResultsController: nil)
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
        configureView()
        handleStates()
        viewModel.fetchCharacters()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    showLoadingState()
                    
                case .loaded:
                    updateData(on: viewModel.currentCharacters())
                    showLoadedState()
                    
                case .error:
                    showErrorState()
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        feedView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        feedView.spinner.stopAnimating()
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Ops! Ocorreu um erro!", message: "Tente novamente mais tarde!", buttonTitle: "Ok") {
            self.feedView.spinner.stopAnimating()
        }
    }
    
    private func configureView() {
        setupSearchController()
        setupDelegates()
        setupDataSource()
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if viewModel.numberOfItems() == 0 && !feedView.spinner.isAnimating {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "Sem personagens"
            
            let searchText = searchController.searchBar.text ?? ""
            
            if searchText.isEmpty {
                config.secondaryText = "Nenhum personagem encontrado."
            } else {
                config.secondaryText = "Nenhum personagem com o termo '\(searchText)'"
            }
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personagem"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Personagens"
        definesPresentationContext = true
    }
    
    private func setupDelegates() {
        feedView.collectionView.delegate = self
    }
    
    private func setupDataSource() {
        feedView.dataSource = UICollectionViewDiffableDataSource<Section, Char>(collectionView: feedView.collectionView, cellProvider: { (collectionView, indexPath, char) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
            let searchText = self.searchController.searchBar.text ?? ""
            cell.configure(char: char, searchText: searchText)
            return cell
        })
    }
    
    private func updateData(on chars: [Char]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Char>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chars)
        DispatchQueue.main.async {
            self.feedView.dataSource.apply(snapshot, animatingDifferences: true)
        }
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.searchBarTextDidChange(searchText: searchText)
        updateData(on: viewModel.currentCharacters())
        feedView.collectionView.reloadData()
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItems = viewModel.numberOfItems()
        
        if indexPath.item >= totalItems - 5 {
            viewModel.fetchCharacters()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let charSelected = viewModel.character(at: indexPath)
        let detailsVM = DetailsViewModel(char: charSelected)
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        detailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
