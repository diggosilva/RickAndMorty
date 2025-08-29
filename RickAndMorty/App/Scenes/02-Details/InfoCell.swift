//
//  InfoCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 28/08/25.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    static let identifier = "InfoCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        contentView.addSubview(stack)
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    func applyStyle(for index: Int) {
        let colors: [UIColor] = [.systemIndigo, .systemMint, .systemPink, .systemOrange]

        let color = colors[index % colors.count]
        contentView.layer.borderColor = color.cgColor
        titleLabel.textColor = color
        contentView.backgroundColor = color.withAlphaComponent(0.2)
    }
}
