//
//  CarListViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation

final class CarListViewModel {
    
    @Published var carSummaryViewModelList: [CarSummaryViewModel]?
    
    private let getCarListUseCase: GetCardList
    
    init() {
        self.getCarListUseCase = GetCardList(repository: CarServiceRepository(dataSource: AppEnvironment.shared.dataSource()))
    }
}

// MARK: usecase
extension CarListViewModel {
    
    func fetchCarList() {
        
    }
}
