//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 05/09/25.
//

import UIKit

class LocationViewController: UIViewController {
    
    let viewModel = LocationViewModel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupDelegatesAndDataSources()
        viewModel.fetchLocations()
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Location"
    }
    
    private func setupDelegatesAndDataSources() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
