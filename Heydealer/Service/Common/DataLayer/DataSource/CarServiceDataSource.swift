//
//  CarServiceDataSource.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

protocol CarServiceDataSourceInterface {
    func fetchCarList() async throws -> [CarDTO]?
}

final class CarServiceDummyDataSource: CarServiceDataSourceInterface {
    
    func fetchCarList() async throws -> [CarDTO]? {
        let status = ["approved", "ended", "expired"]
        
        return (0...10).map { index in
                .init(name: String(index), area: "부산", image: "https://picsum.photos/200/300", imageList: nil, year: "2018", mileage: 100000, fuel: "gasoline", status: status.randomElement(), highest_bid_price: 1000, bids_count: 3, started_at: "20101010101010", end_at: "20141010101010", expire_at: "20251010101010", initial_registration_date: "20101010101010")
        }
    }
}

final class CarServiceRealDataSource: CarServiceDataSourceInterface {
    
    func fetchCarList() async throws -> [CarDTO]? {
        return nil
    }
}
