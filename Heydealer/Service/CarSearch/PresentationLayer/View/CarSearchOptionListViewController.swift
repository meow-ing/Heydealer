//
//  CarSearchOptionListViewController.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import UIKit
import Combine

class CarSearchOptionListViewController: UIViewController {
    typealias Item = CarSearchOptionItem
    
    private lazy var collectionView: UICollectionView = { setupCollectionView() }()
    private lazy var dataSource    = { configureDataSource() }()

    private let viewModel  : CardSearchOptionListViewModelInterface
    private var cancelBags = Set<AnyCancellable>()
    
    init(viewModel: CardSearchOptionListViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: override
extension CarSearchOptionListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
        
        viewModel.fetchOptionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: view model
private extension  CarSearchOptionListViewController {
    
    func bindViewModel() {
        viewModel.optionList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.snapshotData(list)
            }.store(in: &cancelBags)
        
        viewModel.searchFlow
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flow in
                guard let self else { return }
                
                switch flow {
                case .nextOption(let vm)  : self.pushNextSearchOptionListViewController(vm)
                case .finishOption(let vm): break
                }
            }.store(in: &cancelBags)
    }
}


// MARK: data
private extension  CarSearchOptionListViewController {
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Item> {
        let cellRegistraion = cellRegistration()
                                              
        let dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistraion, for: indexPath, item: item)
        }
        
        let titleHeaderRegistraion = titleHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == titleHeaderRegistraion.kind else { return nil }
            
            return collectionView.dequeueConfiguredReusableSupplementary(using: titleHeaderRegistraion.registration, for: indexPath)
        }
        
        return dataSource
    }
    
    func snapshotData(_ optionList: [Item]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        
        snapshot.appendSections([0])
        
        if let optionList {
            snapshot.appendItems(optionList)
        }
        
        dataSource.apply(snapshot)
    }
}

// MARK: flow
private extension CarSearchOptionListViewController {
    
    func pushNextSearchOptionListViewController(_ viewModel: CardSearchOptionListViewModelInterface) {
        let viewController = CarSearchOptionListViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCarListViewController(_ viewModel: CarListViewModel) {
        let viewController = CarListViewController(viewModel: viewModel)
        
        navigationController?.setViewControllers([viewController], animated: true)
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
        
        let titleHeadrSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let titleHeader    = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleHeadrSize, elementKind: titleHeaderKind(), alignment: .top)
        
        section.boundarySupplementaryItems = [titleHeader]
        
        return .init(section: section)
    }
    
    func cellRegistration() -> UICollectionView.CellRegistration<CarSearchOptionItemCell, Item> {
        .init { cell, indexPath, itemIdentifier in
            cell.nameLabel.text  = itemIdentifier.name
            cell.countLabel.text = "\(itemIdentifier.count)" //todo bjy: 1000자리 넘어가면 콤마 표시해야하지만 패스
        }
    }
    
    func titleHeaderRegistration() -> (registration: UICollectionView.SupplementaryRegistration<CarSearchOptionTitleView>, kind: String) {
        let kind  = titleHeaderKind()
        let title = viewModel.title
        
        return (UICollectionView.SupplementaryRegistration(elementKind: kind, handler: { [title] supplementaryView, elementKind, indexPath in
            supplementaryView.titleLabel.text = title
        }), kind)
    }
    
    func titleHeaderKind() -> String {
        String(describing: CarSearchOptionTitleView.self)
    }
    
}
