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
    
    lazy var nameLabel = DSViewBuilder.buildLabel(textAlignment: .center, font: .systemFont(ofSize: 14, weight: .semibold), minimumScaleFactor: 0.5)
    lazy var statusLabel = DSViewBuilder.buildLabel(textAlignment: .center, font: .systemFont(ofSize: 10, weight: .regular))
        
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
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: padding / 2),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    func configure(char: Char, searchText: String) {
        guard let url = URL(string: char.image) else { return }
        photoImageView.sd_setImage(with: url)
        nameLabel.attributedText = highlightedText(fullText: char.name, highlight: searchText)
        statusLabel.text = char.getStatusChar()
    }
    
    private func highlightedText(fullText: String, highlight: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: fullText)

        if !highlight.isEmpty {
            let range = (fullText as NSString).range(of: highlight, options: .caseInsensitive)
            if range.location != NSNotFound {
                attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize), range: range)
            }
        }
        return attributedText
    }
}
