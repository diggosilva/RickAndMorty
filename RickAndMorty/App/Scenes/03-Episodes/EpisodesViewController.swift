//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 02/09/25.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    private let episodesView = EpisodesView()
    
    override func loadView() {
        super.loadView()
        view = episodesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegatesAndDataSources()
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Episode \(indexPath.row + 1)"
        content.secondaryText = "Season 1"
        content.image = UIImage(systemName: "chevron.right")
        cell.contentConfiguration = content
        
        return cell
    }
    
}
