//
//  TabBarController.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 01/09/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    let characters = UINavigationController(rootViewController: FeedViewController())
    let locations = UINavigationController(rootViewController: LocationViewController())
    let episodes = UINavigationController(rootViewController: EpisodesViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    func configureTabBar() {
        characters.tabBarItem.title = "Personagens"
        characters.tabBarItem.image = UIImage(systemName: "person")
        characters.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        locations.tabBarItem.title = "Locais"
        locations.tabBarItem.image = UIImage(systemName: "globe.americas")
        locations.tabBarItem.selectedImage = UIImage(systemName: "globe.americas.fill")
        
        episodes.tabBarItem.title = "Episódios"
        episodes.tabBarItem.image = UIImage(systemName: "tv")
        episodes.tabBarItem.selectedImage = UIImage(systemName: "tv.fill")
        
        viewControllers = [characters, locations, episodes]
    }
}

class LocationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Location"
        view.backgroundColor = .systemYellow
    }
}
