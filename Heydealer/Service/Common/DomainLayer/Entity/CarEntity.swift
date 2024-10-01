//
//  CarEntity.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

enum CarFuel: String {
    case gasoline, diesel, lpg, electric, hybrid, bifuel
    
    var name: String {
        switch self {
        case .gasoline  : return String(localized: "가솔린")
        case .diesel    : return String(localized: "디젤")
        case .lpg       : return String(localized: "LPG")
        case .electric  : return String(localized: "전기")
        case .hybrid    : return String(localized: "하이브리드")
        case .bifuel    : return String(localized: "바이퓨얼")
        }
    }
}

enum CarAutionStatus: String {
    case approved, ended, expired
    
    var name: String {
        switch self {
        case .approved  : return String(localized: "경매중")
        case .ended     : return String(localized: "경매종료")
        case .expired   : return String(localized: "유효기간만료")
        }
    }
}

struct Car {
    let name    : String
    let area    : String
    let year    : String
    let mileage : Int
    let fuel    : CarFuel?
}

struct CarAution {
    let status: CarAutionStatus?
    
    let highestPrice  : Int64?
    let customerCount: Int?
    
    let registDate   : Date
    let startDate    : Date
    let endExpectDate: Date
    let leftDate     : Date?
}
