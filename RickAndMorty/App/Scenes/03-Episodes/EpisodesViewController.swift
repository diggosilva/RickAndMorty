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
        print("DEBUG: CARREGANDO...")
#warning("Implementar loading state com Spinner")
    }
    
    private func showLoadedState() {
        episodesView.tableView.reloadData()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Erro!", message: "Não foi possível carregar os episódios.", buttonTitle: "OK")
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Episodes"
    }
    
    private func setupDelegatesAndDataSources() {
        episodesView.tableView.dataSource = self
    }
}

extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.episode(at: indexPath).name
        cell.contentConfiguration = content
        
        return cell
    }
}
