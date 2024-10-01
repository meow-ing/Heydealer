//
//  CarServiceDTO.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

struct CarDTO: Decodable {
    let name: String?
    let area: String?
    let image: String?
    let imageList: [String]?
    let year: String?
    let mileage: Int?
    let fuel: String?
    let status: String?
    let highest_bid_price: Int?
    let bids_count: Int?
    let started_at: String?
    let end_at: String?
    let expire_at: String?
    let initial_registration_date: String?
}

struct CarSearchOptionDTO: Decodable {
    let name : String
    let count: Int
    let id   : String
}
