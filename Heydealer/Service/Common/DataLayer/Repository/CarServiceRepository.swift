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
                        
                        return .init(info: .init(name: name, area: area, year: year, mileage: mileage, fuel: CarFuel(rawValue: fuel)), image: URL(string: dto.image ?? ""))
                    } as [CarSummary]
                    
                    promise(.success(list))
                } catch {
                    return promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
