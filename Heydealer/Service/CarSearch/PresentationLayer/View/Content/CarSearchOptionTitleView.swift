//
//  CarSearchOptionTitleView.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import UIKit

class CarSearchOptionTitleView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = { setupTitleLabel() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }
}
