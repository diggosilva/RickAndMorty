//
//  ResidentCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 07/09/25.
//

import UIKit

class ResidentCell: UICollectionViewCell {
    
    static let identifier = "ResidentCell"
    
    lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
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
        addSubviews(avatarImageView)
        layer.cornerRadius = 8
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(with resident: Resident) {
        guard let url = URL(string: resident.imageURL) else { return }
        avatarImageView.sd_setImage(with: url)
    }
}
