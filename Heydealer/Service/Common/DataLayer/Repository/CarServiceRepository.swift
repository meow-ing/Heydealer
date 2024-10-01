//
//  CarServiceRepository.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation
import Combine

class CarServiceRepository: CarServiceRepositoryInterface {
    private let dataSource: CarServiceDataSourceInterface
    
    init(dataSource: CarServiceDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    
    func fetchCarList() -> AnyPublisher<[CarSummary]?, Error> {
        Future<[CarSummary]?, Error> { promise in
            Task {
                do {
                    guard let dtoList = try await self.dataSource.fetchCarList() else {
                        return promise(.success(nil))
                    }
                    
                    let list = try dtoList.map { dto in
                        guard let name = dto.name, let area = dto.area, let year = dto.year, let mileage = dto.mileage, let fuel = dto.fuel else {
                            throw NetworkError.invalidData
                        }
                        
                        var aution: CarAution?
                        
                        if let autionStatus = CarAutionStatus(rawValue: dto.status ?? "") {
                            aution = .init(status: autionStatus, highestPrice: nil, customerCount: nil, registDate: nil, startDate: nil, expireDate: dto.expire_at?.date())
                        }
                        
                        return .init(info: .init(name: name, area: area, year: year, mileage: mileage, fuel: CarFuel(rawValue: fuel)), image: URL(string: dto.image ?? ""), aution: aution)
                    } as [CarSummary]
                    
                    promise(.success(list))
                } catch {
                    return promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchSearchOptionBrandList() -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        Future<[CarSearchOptionItem]?, Error> { promise in
            Task {
                do {
                    guard let dtoList = try await self.dataSource.fetchSearchOptionBrandList() else {
                        return promise(.success(nil))
                    }
                    
                    let list = dtoList.map {
                        .init(name: $0.name, count: $0.count, optionID: $0.id)
                    } as [CarSearchOptionItem]
                } catch {
                    return promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchSearchOptionModelGroupList(for brandID: String) -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        Future<[CarSearchOptionItem]?, Error> { promise in
            Task {
                do {
                    guard let dtoList = try await self.dataSource.fetchSearchOptionModelGroupList(for: brandID) else {
                        return promise(.success(nil))
                    }
                    
                    let list = dtoList.map {
                        .init(name: $0.name, count: $0.count, optionID: $0.id)
                    } as [CarSearchOptionItem]
                } catch {
                    return promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchSearchOptionModelList(for modelGroupID: String) -> AnyPublisher<[CarSearchOptionItem]?, Error> {
        Future<[CarSearchOptionItem]?, Error> { promise in
            Task {
                do {
                    guard let dtoList = try await self.dataSource.fetchSearchOptionModelList(for: modelGroupID) else {
                        return promise(.success(nil))
                    }
                    
                    let list = dtoList.map {
                        .init(name: $0.name, count: $0.count, optionID: $0.id)
                    } as [CarSearchOptionItem]
                } catch {
                    return promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
