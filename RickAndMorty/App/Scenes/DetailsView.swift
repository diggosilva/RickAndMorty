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
    
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var episodesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
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
        setupInfoLabels()
    }
    
    private func setHierarchy() {
        addSubviews(imageView, infoStackView, episodesTableView)
        backgroundColor = .systemBackground
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            episodesTableView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16),
            episodesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            episodesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupInfoLabels() {
        let statusStack = makeInfoRow(title: "Status:", valueLabel: statusLabel)
        let speciesStack = makeInfoRow(title: "Espécie:", valueLabel: speciesLabel)
        let genderStack = makeInfoRow(title: "Gênero:", valueLabel: genderLabel)
        let originStack = makeInfoRow(title: "Origem:", valueLabel: originLabel)
        
        [statusStack, speciesStack, genderStack, originStack].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    
    private func makeInfoRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }
    
    func configure(imageURL: String, status: String, species: String, gender: String, origin: String) {
        statusLabel.text = status
        speciesLabel.text = species
        genderLabel.text = gender
        originLabel.text = origin
        
        guard let url = URL(string: imageURL) else { return }
        imageView.sd_setImage(with: url)
    }
}
