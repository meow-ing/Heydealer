//
//  CarSearchOptionItemCell.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import UIKit

class CarSearchOptionItemCell: UICollectionViewCell {
    
    lazy var nameLabel: UILabel  = { setupNameLabel() }()
    lazy var countLabel: UILabel = { setupCountLabel() }()
    
    private lazy var arwLabel: UILabel = { setupCountLabel() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraintsOfSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: sub view
private extension CarSearchOptionItemCell {
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(arwLabel)
        
        arwLabel.text = ">"
    }
    
    func setupNameLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 12)
        
        return label
    }
    
    func setupCountLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 12)
        
        return label
    }
    
    
}

// MARK: sub view
private extension CarSearchOptionItemCell {
    
    func setConstraintsOfSubviews() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: countLabel.leadingAnchor, constant: -10),
            
            arwLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            arwLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: arwLabel.leadingAnchor, constant: -4),
            countLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
}
