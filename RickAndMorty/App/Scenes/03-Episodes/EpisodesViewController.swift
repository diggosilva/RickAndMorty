//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 02/09/25.
//

import UIKit
import Combine

class EpisodesViewController: UIViewController {
    
    private let episodesView = EpisodesView()
    private let viewModel = EpisodesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        view = episodesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegatesAndDataSources()
        handleStates()
        viewModel.fetchEpisodes()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { states in
                switch states {
                case .loading:
                    self.showLoadingState()
                case .loaded:
                    self.showLoadedState()
                case .error:
                    self.showErrorState()
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        episodesView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        episodesView.spinner.stopAnimating()
        episodesView.tableView.reloadData()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Erro!", message: "Não foi possível carregar os episódios.", buttonTitle: "OK") {
            self.episodesView.spinner.stopAnimating()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Episodes"
    }
    
    private func setupDelegatesAndDataSources() {
        episodesView.tableView.dataSource = self
        episodesView.tableView.delegate = self
    }
}

extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesCell.identifier, for: indexPath) as? EpisodesCell else { return UITableViewCell() }
        let episode = viewModel.episode(at: indexPath)
        cell.configure(episode: episode)        
        return cell
    }
}

extension EpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let episode = viewModel.episode(at: indexPath)
        let viewModel = EpisodeDetailViewModel(episode: episode)
        let episodesDetailVC = EpisodeDetailViewController(viewModel: viewModel)
        episodesDetailVC.navigationItem.title = episode.name
        navigationController?.pushViewController(episodesDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.numberOfRows() - 1 {
            viewModel.fetchEpisodes()
        }
    }
}
