//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 21/09/25.
//

import UIKit
import Combine

class EpisodeDetailViewController: UIViewController {
    
    let episodeDetailView = EpisodeDetailView()
    let viewModel: any EpisodeDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any EpisodeDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        super.loadView()
        view = episodeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndDataSources()
        handleStates()
        viewModel.fetchCharactersInEpisode()
    }
    
    private func setupAndDataSources() {
        episodeDetailView.tableView.dataSource = self
        episodeDetailView.tableView.delegate = self
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
        episodeDetailView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        episodeDetailView.spinner.stopAnimating()
        episodeDetailView.tableView.reloadData()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Ops!", message: "Não foi possível carregar os personagens deste episódio.", buttonTitle: "OK") {
            self.episodeDetailView.spinner.stopAnimating()
        }
    }
}

extension EpisodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeDetailCell.identifier, for: indexPath) as? EpisodeDetailCell else { return UITableViewCell() }
        let char = viewModel.characterInEpisode(at: indexPath)
        cell.configure(char: char)
        return cell
    }
}

extension EpisodeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let char = viewModel.characterInEpisode(at: indexPath)
        let viewModel = DetailsViewModel(char: char)
        let detailsVC = DetailsViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: detailsVC)
        navController.navigationItem.title = char.name
        present(navController, animated: true)
    }
}
