//
//  CarServiceDataSource.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

protocol CarServiceDataSourceInterface {
    func fetchCarList() async throws -> [CarDTO]?
    
    func fetchSearchOptionBrandList() async throws -> [CarSearchOptionDTO]?
    func fetchSearchOptionModelGroupList(for brandID: String) async throws -> [CarSearchOptionDTO]?
    func fetchSearchOptionModelList(for modelGroupID: String) async throws -> [CarSearchOptionDTO]?
}

final class CarServiceDummyDataSource: CarServiceDataSourceInterface {
    
    func fetchCarList() async throws -> [CarDTO]? {
        let status = ["approved", "expired"]
        
        return (0...10).map { index in
                .init(name: String("차차차차차차차차차차차차차차"), area: "부산", image: "https://picsum.photos/200/300", imageList: nil, year: "2018", mileage: 101100, fuel: "gasoline", status: status.randomElement(), highest_bid_price: 1000, bids_count: 3, started_at: "20101010101010", end_at: "20141010101010", expire_at: "20251010101010", initial_registration_date: "20101010101010")
        }
    }
    
    func fetchSearchOptionBrandList() async throws -> [CarSearchOptionDTO]? {
        [
            .init(name: "BMW", count: 342, id: "0"),
            .init(name: "BMW-1", count: 342, id: "1"),
            .init(name: "BMW-2", count: 342, id: "2"),
            .init(name: "BMW-3", count: 342, id: "3"),
            .init(name: "BMW-4", count: 342, id: "4")
        ]
    }
    
    func fetchSearchOptionModelGroupList(for brandID: String) async throws -> [CarSearchOptionDTO]? {
        [
            .init(name: "쿠퍼", count: 342, id: "0"),
            .init(name: "쿠퍼-1", count: 342, id: "1"),
            .init(name: "쿠퍼-2", count: 342, id: "2"),
            .init(name: "쿠퍼-3", count: 342, id: "3"),
            .init(name: "쿠퍼-4", count: 342, id: "4")
        ]
    }
    
    func fetchSearchOptionModelList(for modelGroupID: String) async throws -> [CarSearchOptionDTO]? {
        [
            .init(name: "쿠퍼", count: 342, id: "0"),
            .init(name: "쿠퍼-11", count: 342, id: "1"),
            .init(name: "쿠퍼-21", count: 342, id: "2"),
            .init(name: "쿠퍼-31", count: 342, id: "3"),
            .init(name: "쿠퍼-41", count: 342, id: "4")
        ]
    }
}

// MARK: real server
final class CarServiceRealDataSource: CarServiceDataSourceInterface {
    
    func fetchCarList() async throws -> [CarDTO]? {
        return nil
    }
    
    func fetchSearchOptionBrandList() async throws -> [CarSearchOptionDTO]? {
        return nil
    }
    
    func fetchSearchOptionModelGroupList(for brandID: String) async throws -> [CarSearchOptionDTO]? {
        return nil
    }
    
    func fetchSearchOptionModelList(for modelGroupID: String) async throws -> [CarSearchOptionDTO]? {
        return nil
    }
}
