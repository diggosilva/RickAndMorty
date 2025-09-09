//
//  LocationCell.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 07/09/25.
//

import UIKit
import SDWebImage

struct Resident {
    let name: String
    let imageURL: String
}

class LocationCell: UITableViewCell {
    
    static let identifier = "LocationCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var nameLabel = DSViewBuilder.buildLabel(font: .preferredFont(forTextStyle: .headline))
    lazy var typeLabel = DSViewBuilder.buildLabel(font: .preferredFont(forTextStyle: .subheadline))
    lazy var dimensionLabel = DSViewBuilder.buildLabel(font: .preferredFont(forTextStyle: .subheadline))
    lazy var dividerView = DSViewBuilder.buildDivider()
    lazy var residentLabel = DSViewBuilder.buildLabel(text: "Residents", font: .preferredFont(forTextStyle: .headline))
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ResidentCell.self, forCellWithReuseIdentifier: ResidentCell.identifier)
        cv.backgroundColor = .systemRed
        cv.layer.cornerRadius = 8
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        contentView.addSubviews(containerView, nameLabel, typeLabel, dividerView, residentLabel, collectionView)
        contentView.backgroundColor = .clear
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray2.cgColor
        
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding / 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding / 2),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding / 2),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            dividerView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: padding / 2),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            residentLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: padding / 2),
            residentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: residentLabel.bottomAnchor, constant: padding / 2),
            collectionView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    var residents: [Resident] = []
    let viewModel = LocationViewModel()
    
    func configure(with location: Location, residents: [Resident]) {
        nameLabel.text = location.name
        typeLabel.text = location.type + " • " + location.dimension
        self.residents = residents
        collectionView.reloadData()
    }
}

extension LocationCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return residents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResidentCell.identifier, for: indexPath) as? ResidentCell else {
            return UICollectionViewCell()
        }
        
        let resident = residents[indexPath.item]
        cell.nameLabel.text = resident.name
        cell.backgroundColor = .blue // Tento mudar a cor da célula da CollectionView mas não muda.
        return cell
    }
}
