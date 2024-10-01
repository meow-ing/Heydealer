//
//  CarServiceRepositoryInterface.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation
import Combine

protocol CarServiceRepositoryInterface {
    func fetchCarList() -> AnyPublisher<[CarSummary]?, Error>
    
    func fetchSearchOptionBrandList() -> AnyPublisher<[CarSearchOptionItem]?, Error>
    func fetchSearchOptionModelGroupList(for brandID: String) -> AnyPublisher<[CarSearchOptionItem]?, Error>
    func fetchSearchOptionModelList(for modelGroupID: String) -> AnyPublisher<[CarSearchOptionItem]?, Error>
}
