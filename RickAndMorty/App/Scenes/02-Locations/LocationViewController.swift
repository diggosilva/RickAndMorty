//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 05/09/25.
//

import UIKit

class LocationViewController: UIViewController {
    
    private let locationView = LocationView()
    private let viewModel = LocationViewModel()
    
    override func loadView() {
        super.loadView()
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegatesAndDataSources()
        viewModel.fetchLocations()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Planeta Terra"
        content.secondaryText = "Césio 137"
        content.image = UIImage(systemName: "map")
        
        cell.contentConfiguration = content
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
