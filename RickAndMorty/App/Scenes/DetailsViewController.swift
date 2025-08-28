//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    private let detailsView = DetailsView()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        navigationItem.title = viewModel.name
        
        detailsView.configure(
            imageURL: viewModel.imageURL,
            status: viewModel.status,
            species: viewModel.species,
            gender: viewModel.gender,
            origin: viewModel.origin
        )
        
        
        detailsView.episodesTableView.delegate = self
        detailsView.episodesTableView.dataSource = self
    }
}

// MARK: - TableView
extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = viewModel.cellForRow(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Episódio \(id)"
        return cell
    }
}
