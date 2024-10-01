//
//  HighlightCarItemCell.swift
//  Heydealer
//
//  Created by 지윤 on 9/30/24.
//

import UIKit
import Combine

class HighlightCarItemCell: UICollectionViewCell {
    
    private lazy var hStackView     : UIStackView = { setupHStackView() }()
    private lazy var imageView      : UIImageView = { setupImageView()} ()
            lazy var statusView     : CarItemStatusView = { setupStatusView() }()
    private lazy var infoBoxView    : UIView = { setupInfoBoxView() }()
    private lazy var nameLabel      : UILabel = { setupNameLabel() }()
    private lazy var yearLabel      : UILabel = { setupInfoLabel() }()
    private lazy var mileageLabel   : UILabel = { setupInfoLabel() }()
    private lazy var areaLabel      : UILabel = { setupInfoLabel() }()
    
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
        yearLabel.text      = nil
        mileageLabel.text   = nil
        areaLabel.text      = nil
    }
}
// MARK: public
extension HighlightCarItemCell {
    
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
    
    func setYear(_ year: String) {
        yearLabel.text = String(localized: "연식 \(year)")
    }
    
    func setMilage(_ mileage: String) {
        mileageLabel.text = String(localized: "주행 \(mileage)")
    }
    
    func setArea(_ area: String) {
        areaLabel.text = String(localized: "지역 \(area)")
    }
    
}

// MARK: sub view
private extension HighlightCarItemCell {
    
    func addSubviews() {
        contentView.addSubview(hStackView)
        
        hStackView.addArrangedSubview(imageView)
        hStackView.addArrangedSubview(infoBoxView)

        imageView.addSubview(statusView)
        
        infoBoxView.addSubview(nameLabel)
        infoBoxView.addSubview(yearLabel)
        infoBoxView.addSubview(mileageLabel)
        infoBoxView.addSubview(areaLabel)
    }
    
    func setupHStackView() -> UIStackView {
        let view = UIStackView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.axis         = .horizontal
        view.spacing      = 10
        view.distribution = .fillEqually
        
        return view
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
    
    func setupInfoBoxView() -> UIView {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        
        return view
    }
    
    func setupNameLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 2
        label.font          = .boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }
    
    func setupInfoLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
}

// MARK: layout
private extension HighlightCarItemCell {
    
    func setConstraintsOfSubviews() {
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        let imageHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        imageHeight.priority = .init(rawValue: 999)
        
        NSLayoutConstraint.activate([
            imageHeight,
            
            statusView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoBoxView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: infoBoxView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoBoxView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoBoxView.trailingAnchor),
            
            mileageLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),
            mileageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            mileageLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoBoxView.trailingAnchor),
            
            areaLabel.topAnchor.constraint(equalTo: mileageLabel.bottomAnchor, constant: 4),
            areaLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            areaLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoBoxView.trailingAnchor),
        ])
    }
    
}

