//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 05/09/25.
//

import UIKit

class LocationViewController: UIViewController {
    
    let viewModel = LocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        view.backgroundColor = .systemYellow
        
        viewModel.fetchLocations()
    }
    
}
