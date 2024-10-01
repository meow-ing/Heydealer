//
//  NormalCarItemCell.swift
//  Heydealer
//
//  Created by 지윤 on 9/30/24.
//

import UIKit
import Combine

class NormalCarItemCell: UICollectionViewCell {
    
    private lazy var imageView      : UIImageView = { setupImageView()} ()
            lazy var statusView     : CarItemStatusView = { setupStatusView() }()
    private lazy var nameLabel      : UILabel = { setupNameLabel() }()
    private lazy var summaryLabel   : UILabel = { setupSummaryLabel() }()
    
    private var autionStatusCancel: AnyCancellable?
    private var autionTimerCancel : AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        addSubviews()
        setConstraintsOfSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        autionStatusCancel?.cancel()
        autionTimerCancel?.cancel()
        
        statusView.reset()
        
        statusView.isHidden = true
        imageView.image     = nil
        nameLabel.text      = nil
        summaryLabel.text   = nil
    }
}
// MARK: public
extension NormalCarItemCell {
    
    func bindingAutionStatus(_ publisher: Published<(name: String, color: UIColor)?>.Publisher?) {
        autionStatusCancel?.cancel()
        
        autionStatusCancel = publisher?
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
            guard let self, let status else { return }
                self.statusView.isHidden        = false
                self.statusView.backgroundColor = status.color
                self.statusView.setStatus(status.name)
        })
    }
    
    func bindingAutionTimeer(_ publisher: AnyPublisher<String?, Never>?) {
        autionTimerCancel?.cancel()
        
        autionTimerCancel = publisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeStamp in
                guard let timeStamp else { return }
                
                self?.statusView.setTime(timeStamp)
            }
    }
    
    func setImage(_ url: URL?) {
        imageView.loadImage(from: url)
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setSummary(_ summary: String) {
        summaryLabel.text = summary
    }
    
}

// MARK: sub view
private extension NormalCarItemCell {
    
    func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(summaryLabel)

        imageView.addSubview(statusView)
    }
    
    func setupImageView() -> UIImageView {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
                
        return view
    }
    
    func setupStatusView() -> CarItemStatusView {
        let view = CarItemStatusView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    func setupNameLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 2
        label.font          = .boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }
    
    func setupSummaryLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 11)
        
        return label
    }
    
}

// MARK: layout
private extension NormalCarItemCell {
    
    func setConstraintsOfSubviews() {
        let imageBottom = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        
        imageBottom.priority = .init(999)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageBottom,
            
            statusView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
    
}

