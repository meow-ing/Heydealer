//
//  CarListViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation
import Combine

struct CarListSearchOption {
    let searchText   : String
    let searchModelID: String
}

final class CarListViewModel {
    
    @Published var carSummaryViewModelList: [CarSummaryViewModel]?
    @Published var searchText             : String?
    
    private let getCarListUseCase: GetCardList
    private var searchOption     : CarListSearchOption?
    private var page             = 0
    
    init(searchOption: CarListSearchOption? = nil) {
        self.getCarListUseCase = GetCardList(repository: CarServiceRepository(dataSource: AppEnvironment.shared.dataSource()))
        
        guard let searchOption else { return }
        
        self.searchOption = searchOption
        self.searchText   = searchOption.searchText
    }
    
}

// MARK: usecase
extension CarListViewModel {
    
    enum FetchType {
        case first, refresh, loadMore
        case search(String?)
    }
    
    func fetchCarList(with type: FetchType) -> AnyPublisher<Never, Error> {
        var fetchPage  = 0
        var willSearch = searchText
        
        switch type {
        case .loadMore        : fetchPage  = page + 1
        case .search(let text): willSearch = text
            
        default: break
        }
        
        return fetchCarList(at: fetchPage, searchText: willSearch)
            .receive(on: DispatchQueue.main)
            .map { [weak self] _ in
                self?.page       = fetchPage
                self?.searchText = willSearch
                
                return
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func canLoadMore(at itemIndex: Int) -> Bool {
        guard let carSummaryViewModelList, !carSummaryViewModelList.isEmpty else { return false }
        
        return itemIndex == carSummaryViewModelList.count - 1
    }
    
    private func fetchCarList(at page: Int, searchText: String?) -> AnyPublisher<Void, Error> {
        getCarListUseCase.excute(page: page, searchText: searchText)
            .receive(on: DispatchQueue.main)
            .map { [weak self] data in
                self?.didFetchData(data, append: page > 0)
                return
            }
            .eraseToAnyPublisher()
    }
    
    private func didFetchData(_ data: [CarSummary]?, append: Bool = false) {
        let oldTotalCount = append ? carSummaryViewModelList?.count ?? 0 : 0
        let convertList   = data?.enumerated().map { [oldTotalCount] car in
            let id = "(\(oldTotalCount + car.offset))".appending(String(Date().timeIntervalSinceNow))
            
             return .init(identifier: id, data: car.element)
        } as [CarSummaryViewModel]?
        
        guard let oldList = carSummaryViewModelList, append else {
            carSummaryViewModelList = convertList
            return
        }
        
        carSummaryViewModelList = oldList + (convertList ?? [])
    }
    
    
}

// MARK: view model
extension CarListViewModel {
    
    func searchOptionBarandListViewModel() -> CardSearchOptionListViewModelInterface {
        CardSearchOptionBrandListViewModel()
    }
}

