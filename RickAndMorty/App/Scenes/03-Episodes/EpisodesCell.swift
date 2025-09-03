//
//  EpisodesCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 02/09/25.
//

import UIKit

class EpisodesCell: UITableViewCell {
    
    static let identifier = "EpisodesCell"
    
    lazy var seasonEpisodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    lazy var episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [seasonEpisodeLabel, episodeTitleLabel, airDateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stackView.spacing = 4
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.systemBlue.cgColor
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews(stackView)
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding * 2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding * 2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    private let seasonColors: [String : UIColor] = [
        "S01" : .systemIndigo,
        "S02" : .systemMint,
        "S03" : .systemPink,
        "S04" : .systemGreen
    ]
        
    func configure(episode: Episode) {
        seasonEpisodeLabel.text = "Episode: \(episode.episode)"
        episodeTitleLabel.text = episode.name
        airDateLabel.text = "Aired on: \(episode.airDate)"
        
        let seasonPrefix = String(episode.episode.prefix(3))
        
        let borderColor = seasonColors[seasonPrefix] ?? .systemOrange
        stackView.layer.borderColor = borderColor.cgColor
    }
}
