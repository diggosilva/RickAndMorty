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
    
    lazy var nameLabel = DSViewBuilder.buildLabel(font: .preferredFont(forTextStyle: .headline))
    lazy var statusLabel = DSViewBuilder.buildLabel(font: .preferredFont(forTextStyle: .subheadline))
    
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
        contentView.addSubview(charImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
    }
    
    private func setConstraints() {
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            charImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            charImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            charImageView.widthAnchor.constraint(equalToConstant: 40),
            charImageView.heightAnchor.constraint(equalTo: charImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: charImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 2),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        charImageView.sd_setImage(with: url)
        nameLabel.text = char.name
        statusLabel.text = char.status
        self.accessoryType = .disclosureIndicator
    }
}
