//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let detailsView = DetailsView()
    private let viewModel: DetailsViewModelProtocol
    
    init(viewModel: DetailsViewModelProtocol) {
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

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let episodeId = viewModel.cellForRow(at: indexPath)
        cell.textLabel?.text = "Episódio \(episodeId)"
        return cell
    }
}
