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
        setupNavigationBar()
        setupAndDataSources()
        handleStates()
        viewModel.fetchCharactersInEpisode()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Episode Detail"
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
        print("⚠️ CARREGANDO PERSONAGENS DO EPISÓDIO...")
    }
    
    private func showLoadedState() {
        print("🟢 CARREGADO PERSONAGENS DO EPISÓDIO...")
        episodeDetailView.tableView.reloadData()
    }
    
    private func showErrorState() {
        
    }
}

extension EpisodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Personagem \(indexPath.row + 1)"
        content.secondaryText = "Descrição"
        content.image = UIImage(systemName: "person.fill")
        
        cell.contentConfiguration = content
        return cell
    }
}

extension EpisodeDetailViewController: UITableViewDelegate {
    
}
