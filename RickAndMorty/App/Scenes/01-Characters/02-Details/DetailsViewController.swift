//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    private let detailsView = DetailsView()
    private let viewModel: any DetailsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegatesAndDataSources()
        configureViewData()
        setupNavBar()
        handleStates()
        viewModel.fetchEpisodes()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading: self?.showLoadingState()
                case .loaded: self?.showLoadedState()
                case .error: self?.showErrorState()
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        print("CARREGANDO DADOS...")
        detailsView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        print("CARREGAMENTO DE DADOS CONCLUÍDO!")
        detailsView.spinner.stopAnimating()
        detailsView.episodesTableView.reloadData()
    }
    
    private func showErrorState() {
        detailsView.spinner.stopAnimating()
        showCustomAlert(title: "Ops!", message: "Ocorreu um erro ao carregar os Episódios na tela de Detalhes.", buttonTitle: "OK")
    }
    
    private func setupNavBar() {
        navigationItem.title = viewModel.name
    }
    
    private func setupDelegatesAndDataSources() {
        detailsView.infoCollectionView.dataSource = self
        detailsView.infoCollectionView.delegate = self
        detailsView.episodesTableView.dataSource = self
        detailsView.episodesTableView.delegate = self
    }
    
    private func configureViewData() {
        detailsView.configure(imageURL: viewModel.imageURL)
        detailsView.infoCollectionView.reloadData()
        detailsView.episodesTableView.reloadData()
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfInfoItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCellCollection.identifier, for: indexPath) as? DetailsCellCollection else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.infoItem(at: indexPath)
        cell.configure(title: item.title, value: item.value)
        cell.applyStyle(for: indexPath.item)
        return cell
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesCell.identifier, for: indexPath) as? EpisodesCell else { return UITableViewCell() }
        let episode = viewModel.cellForRow(at: indexPath)
        cell.configure(episode: episode)
        return cell
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = viewModel.cellForRow(at: indexPath)
        let viewModel = EpisodeDetailViewModel(episode: episode)
        let episodeDetailVC = EpisodeDetailViewController(viewModel: viewModel)
        episodeDetailVC.navigationItem.title = episode.name
        navigationController?.pushViewController(episodeDetailVC, animated: true)
    }
}
