//
//  EpisodeDetailCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 21/09/25.
//

import UIKit
import SDWebImage

final class EpisodeDetailCell: UITableViewCell {
    
    static let identifier: String = "EpisodeDetailCell"
    
    lazy var charImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
   
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        return label
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
        addSubviews(charImageView, nameLabel, statusLabel)
    }
    
    private func setConstraints() {
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            charImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            charImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            charImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            charImageView.widthAnchor.constraint(equalToConstant: 40),
            charImageView.heightAnchor.constraint(equalTo: charImageView.widthAnchor),
            charImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            nameLabel.topAnchor.constraint(equalTo: charImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: charImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            statusLabel.leadingAnchor.constraint(equalTo: charImageView.trailingAnchor, constant: padding),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            statusLabel.bottomAnchor.constraint(equalTo: charImageView.bottomAnchor),
        ])
    }
    
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        charImageView.sd_setImage(with: url)
        nameLabel.text = char.name
        statusLabel.text = char.status
    }
}
