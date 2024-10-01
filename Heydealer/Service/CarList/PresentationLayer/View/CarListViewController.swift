//
//  CarListViewController.swift
//  Heydealer
//
//  Created by 지윤 on 9/30/24.
//

import UIKit

class CarListViewController: UIViewController {
    typealias Item = CarSummaryViewModel
    
    private lazy var searchButton  : UITextField = { setupSearchButton() }()
    private lazy var collectionView: UICollectionView = { setupCollectionView() }()
    
    private lazy var dataSource = { configureDataSource() }()

}

// MARK: override
extension CarListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        snapshotInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: data
private extension  CarListViewController {
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Item> {
        let highlightCarItemCellRegistraion = highlightCarItemCellRegistration()
        let normalCarItemCellRegistration   = normalCarItemCellRegistration()
                                              
        let dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard indexPath.row % 5 == 0 else {
                return collectionView.dequeueConfiguredReusableCell(using: normalCarItemCellRegistration, for: indexPath, item: item)
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: highlightCarItemCellRegistraion, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    func snapshotInitData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        
        snapshot.appendSections([0])
        //snapshot.appendItems([0, 1, 2, 3, 4, 5])
        
        dataSource.apply(snapshot)
    }
}

// MARK: flow
private extension CarListViewController {
    
    func pushBrandSearchViewController() {
        let viewController = CarSearchOptionListViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: configure ui
private extension CarListViewController {
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchButton)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSearchButton() -> UITextField {
        let view                = UITextField()
        let searchImageView     = UIImageView(image: .init(systemName: "magnifyingglass"))
        let searchImageBoxView  = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageBoxView.translatesAutoresizingMaskIntoConstraints = false
        
        searchImageView.tintColor = .lightGray
        
        searchImageBoxView.addSubview(searchImageView)
        
        NSLayoutConstraint.activate([
            searchImageBoxView.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor, constant: -10),
            searchImageBoxView.trailingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 10),
            searchImageBoxView.heightAnchor.constraint(equalTo: searchImageView.heightAnchor)
        ])
        
        view.delegate = self
        
        view.placeholder     = String(localized: "제조사‧모델로 검색")
        view.leftView        = searchImageBoxView
        view.leftViewMode    = .always
        view.clearButtonMode = .always
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.lightGray.cgColor
        
        return view
    }
    
    func setupCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

// MARK: collection view layout
private extension CarListViewController {
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemHeight = 200.0
        let vSpacing   = 10.0
        
        let highlightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
        let highlightItem     = NSCollectionLayoutItem(layoutSize: highlightItemSize)
        
        let normalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let normalItem     = NSCollectionLayoutItem(layoutSize: normalItemSize)
        
        let normalItemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
        let normalItemGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: normalItemGroupSize, subitems: [normalItem])
        
        normalItemGroup.interItemSpacing = .fixed(10)
        
        let itemStylePatternGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let itemStylePatternGroup     = NSCollectionLayoutGroup.vertical(layoutSize: itemStylePatternGroupSize, subitems: [highlightItem, normalItemGroup, normalItemGroup])
        
        itemStylePatternGroup.interItemSpacing = .fixed(vSpacing)
        
        let section = NSCollectionLayoutSection(group: itemStylePatternGroup)
        
        section.interGroupSpacing = vSpacing
        section.contentInsets     = .init(top: 10, leading: 25, bottom: 20, trailing: 25)
        
        return .init(section: section)
    }
    
    func highlightCarItemCellRegistration() -> UICollectionView.CellRegistration<HighlightCarItemCell, Item> {
        .init { cell, indexPath, itemIdentifier in
            
        }
    }
    
    func normalCarItemCellRegistration() -> UICollectionView.CellRegistration<NormalCarItemCell, Item> {
        .init { cell, indexPath, itemIdentifier in
            
        }
    }
}

// MARK: UITextFieldDelegate
extension CarListViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pushBrandSearchViewController()
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        true
    }
    
}
