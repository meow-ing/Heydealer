//
//  GetCardSearchOptionListUsecase.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation
import Combine

enum GetCardSearchOptionListError: Error {
    case invalidOptionID
}

protocol GetCardSearchOptionListUsecase {
    var repository: CarServiceRepositoryInterface { get set }
    
    func excute(_ optionID: String?) -> AnyPublisher<[CarSearchOptionItem]?, Error>
}

class GetCardSearchOptionBrandList {
    let repository: CarServiceRepositoryInterface
    
    init(repository: CarServiceRepositoryInterface) {
        self.repository = repository
    }
    
    func excute(_ optionID: String?) -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        repository.fetchSearchOptionBrandList()
    }
}

class GetCardSearchOptionModelGroupList {
    let repository: CarServiceRepositoryInterface
    
    init(repository: CarServiceRepositoryInterface) {
        self.repository = repository
    }
    
    func excute(_ optionID: String?) -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        guard let optionID else {
            return Fail(error: GetCardSearchOptionListError.invalidOptionID)
                .eraseToAnyPublisher()
        }
        
        return repository.fetchSearchOptionModelGroupList(for: optionID)
    }
}

class GetCardSearchOptionModelList {
    let repository: CarServiceRepositoryInterface
    
    init(repository: CarServiceRepositoryInterface) {
        self.repository = repository
    }
    
    func excute(_ optionID: String?) -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        guard let optionID else {
            return Fail(error: GetCardSearchOptionListError.invalidOptionID)
                .eraseToAnyPublisher()
        }
        
        return repository.fetchSearchOptionModelList(for: optionID)
    }
}
