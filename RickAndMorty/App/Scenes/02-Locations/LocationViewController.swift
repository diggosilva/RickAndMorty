//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 05/09/25.
//

import UIKit
import Combine

class LocationViewController: UIViewController {
    
    private let locationView = LocationView()
    private let viewModel = LocationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegatesAndDataSources()
        handleStates()
        viewModel.fetchLocations()
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
        locationView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        locationView.spinner.stopAnimating()
        locationView.tableView.reloadData()
    }
    
    private func showErrorState() {
        showCustomAlert(title: "Ops...", message: "Não foi possível carregar os Locais!", buttonTitle: "Ok") {
            self.locationView.spinner.stopAnimating()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Location"
    }
    
    private func setupDelegatesAndDataSources() {
        locationView.tableView.dataSource = self
        locationView.tableView.delegate = self
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else { return UITableViewCell() }
        cell.configure(with: viewModel.location(at: indexPath))
        return cell
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 1 {
            viewModel.fetchLocations()
        }
    }
}
