//
//  CarListViewController.swift
//  Heydealer
//
//  Created by 지윤 on 9/30/24.
//

import UIKit
import Combine

class CarListViewController: UIViewController {
    typealias Item = CarSummaryViewModel
    
    private lazy var searchButton  : UITextField = { setupSearchButton() }()
    private lazy var collectionView: UICollectionView = { setupCollectionView() }()
    
    private lazy var dataSource = { configureDataSource() }()
    
    private let viewModel  = CarListViewModel()
    private var cancelBags = Set<AnyCancellable>()

}

// MARK: override
extension CarListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
        
        fetchCarList(with: .first)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: view model
private extension  CarListViewController {
    
    func bindViewModel() {
        viewModel.$carSummaryViewModelList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.snapshotData(data)
            }.store(in: &cancelBags)
    }
    
    func fetchCarList(with type: CarListViewModel.FetchType) {
        viewModel.fetchCarList(with: type)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(_): break //todo bjy: show error alert
                default: break
                }
            } receiveValue: { _ in
            }
            .store(in: &cancelBags)

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
    
    func snapshotData(_ data: [Item]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        
        snapshot.appendSections([0])
        
        if let data {
            snapshot.appendItems(data)
        }
        
        dataSource.apply(snapshot)
    }
}

// MARK: flow
private extension CarListViewController {
    
    func pushBrandSearchViewController() {
        let viewController = CarSearchOptionListViewController(viewModel: viewModel.searchOptionBarandListViewModel())
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: action
private extension CarListViewController {
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        fetchCarList(with: .refresh)
        
        sender.endRefreshing()
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
        
        view.delegate = self
        
        view.refreshControl = UIRefreshControl()
        view.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        
        return view
    }
}

// MARK: collection view layout
private extension CarListViewController {
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let vSpacing = 10.0
        
        let highlightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let highlightItem     = NSCollectionLayoutItem(layoutSize: highlightItemSize)
        
        let normalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
        let normalItem     = NSCollectionLayoutItem(layoutSize: normalItemSize)
        
        let normalItemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let normalItemGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: normalItemGroupSize, subitems: [normalItem])
        
        normalItemGroup.interItemSpacing = .fixed(10)
        
        let itemStylePatternGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let itemStylePatternGroup     = NSCollectionLayoutGroup.vertical(layoutSize: itemStylePatternGroupSize, subitems: [highlightItem, normalItemGroup, normalItemGroup])
        
        itemStylePatternGroup.interItemSpacing = .fixed(vSpacing)
        
        let section = NSCollectionLayoutSection(group: itemStylePatternGroup)
        
        section.interGroupSpacing = vSpacing
        section.contentInsets     = .init(top: 10, leading: 25, bottom: 20, trailing: 25)
        
        return .init(section: section)
    }
    
    func highlightCarItemCellRegistration() -> UICollectionView.CellRegistration<HighlightCarItemCell, Item> {
        .init { cell, indexPath, itemIdentifier in
            cell.bindingAutionStatus(itemIdentifier.$autionStatus)
            cell.bindingAutionTimeer(itemIdentifier.autionTimeStamp())
            
            cell.setImage(itemIdentifier.data.image)
            cell.setName(itemIdentifier.name())
            cell.setYear(itemIdentifier.year())
            cell.setMilage(itemIdentifier.mileage())
            cell.setArea(itemIdentifier.area())
        }
    }
    
    func normalCarItemCellRegistration() -> UICollectionView.CellRegistration<NormalCarItemCell, Item> {
        .init { cell, indexPath, itemIdentifier in
            cell.bindingAutionStatus(itemIdentifier.$autionStatus)
            cell.bindingAutionTimeer(itemIdentifier.autionTimeStamp())
            
            cell.setImage(itemIdentifier.data.image)
            cell.setName(itemIdentifier.name())
            cell.setSummary(itemIdentifier.summary())
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

// MARK: UICollectionViewDelegate
extension CarListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.canLoadMore(at: indexPath.row) else { return }

        fetchCarList(with: .loadMore)
    }
    
}
