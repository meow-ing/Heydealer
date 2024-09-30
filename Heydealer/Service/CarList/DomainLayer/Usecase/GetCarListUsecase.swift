//
//  GetCarListUsecase.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation
import Combine

class GetCardList {
    private let repository: CarServiceRepositoryInterface
    
    init(repository: CarServiceRepositoryInterface) {
        self.repository = repository
    }
    
    func excute() -> AnyPublisher<[CarSummary]?, Error>? {
        repository.fetchCarList()
    }
}
