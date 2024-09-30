//
//  CarSearchOptionListViewController.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import UIKit

class CarSearchOptionListViewController: UIViewController {

    private lazy var collectionView: UICollectionView = { setupCollectionView() }()
    
    private lazy var dataSource = { configureDataSource() }()
}

// MARK: override
extension CarSearchOptionListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        snapshotInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: data
private extension  CarSearchOptionListViewController {
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Int> {
        let cellRegistraion = cellRegistration()
                                              
        let dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistraion, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    func snapshotInitData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([0, 1, 2, 3, 4, 5])
        
        dataSource.apply(snapshot)
    }
}

// MARK: configure ui
private extension CarSearchOptionListViewController {
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

// MARK: collection view layout
private extension CarSearchOptionListViewController {
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item     = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 10
        section.contentInsets     = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
        
        return .init(section: section)
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<CarSearchOptionItemCell, Int> {
        .init { cell, indexPath, itemIdentifier in
            
        }
    }
    
}
