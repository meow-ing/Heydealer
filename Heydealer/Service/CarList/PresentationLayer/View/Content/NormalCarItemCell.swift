//
//  NormalCarItemCell.swift
//  Heydealer
//
//  Created by 지윤 on 9/30/24.
//

import UIKit

class NormalCarItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
