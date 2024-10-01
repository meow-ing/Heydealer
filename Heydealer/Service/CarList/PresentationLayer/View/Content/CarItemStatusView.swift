//
//  CarItemStatusView.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import UIKit

class CarItemStatusView: UIView {

    private lazy var statusLabel: UILabel = { setupStatusLabel() }()
    private lazy var timeLabel  : UILabel = { setupTimeLabel() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraintsOfSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: public
extension CarItemStatusView {
    
    func reset() {
        statusLabel.text = nil
        timeLabel.text   = nil
    }
    
    func setStatus(_ status: String) {
        statusLabel.text = status
    }
    
    func setTime(_ time: String) {
        timeLabel.text = time
    }
}

// MARK: sub view
private extension CarItemStatusView {
    
    func addSubviews() {
        addSubview(statusLabel)
        addSubview(timeLabel)
    }
    
    func setupStatusLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font      = .boldSystemFont(ofSize: 11)
        
        return label
    }
    
    func setupTimeLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor     = .white
        label.font          = .systemFont(ofSize: 11)
        label.textAlignment = .right
        
        return label
    }
    
}

// MARK: layout
private extension CarItemStatusView {
    
    func setConstraintsOfSubviews() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: statusLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        statusLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
}


