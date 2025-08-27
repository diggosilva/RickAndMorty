//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
}
