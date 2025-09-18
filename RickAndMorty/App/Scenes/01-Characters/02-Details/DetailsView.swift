//
//  DetailsView.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import UIKit

class DetailsView: UIView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 42) / 2, height: 70)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.register(DetailsCellCollection.self, forCellWithReuseIdentifier: DetailsCellCollection.identifier)
        return cv
    }()
    
    lazy var inEpisodesLabel = DSViewBuilder.buildLabel(text: "NOS EPISÓDIOS", font: .preferredFont(forTextStyle: .subheadline))
    
    lazy var episodesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.register(EpisodesCell.self, forCellReuseIdentifier: EpisodesCell.identifier)
        return tv
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        return spinner
    }()
    
    let statusLabel = UILabel()
    let speciesLabel = UILabel()
    let genderLabel = UILabel()
    let originLabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews(imageView, infoCollectionView, inEpisodesLabel, episodesTableView, spinner)
        backgroundColor = .systemBackground
    }
    
    private func setConstraints() {
        let padding: CGFloat = 14
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            infoCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            infoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            infoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            infoCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            inEpisodesLabel.topAnchor.constraint(equalTo: infoCollectionView.bottomAnchor, constant: padding),
            inEpisodesLabel.leadingAnchor.constraint(equalTo: infoCollectionView.leadingAnchor),
            inEpisodesLabel.trailingAnchor.constraint(equalTo: infoCollectionView.trailingAnchor),
            
            episodesTableView.topAnchor.constraint(equalTo: inEpisodesLabel.bottomAnchor),
            episodesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            episodesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: episodesTableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: episodesTableView.centerYAnchor)
        ])
    }
    
    func configure(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        imageView.sd_setImage(with: url)
    }
}
