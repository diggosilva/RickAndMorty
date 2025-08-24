//
//  FeedCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 23/08/25.
//

import UIKit
import SDWebImage

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .footnote)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        applyShadow(view: self)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews(photoImageView, nameLabel, statusLabel)
        backgroundColor = .systemBackground
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 180),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        
        photoImageView.sd_setImage(with: url)
        nameLabel.text = char.name
        statusLabel.text = getStatusChar(char: char)
    }
    
    private func getStatusChar(char: Char) -> String {
        if char.status == "Alive" {
            return "🟢 Vivo"
        } else if char.status == "Dead" {
            return "🔴 Morto"
        } else {
            return "🟡 Desconhecido"
        }
    }
    
    private func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.35
        view.layer.shadowRadius = 5.0
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
    }
}
