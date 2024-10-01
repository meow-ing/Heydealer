//
//  Entity.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

struct CarSearchOptionItem: Hashable {
    let name    : String
    let count   : Int
    let optionID: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(optionID)
    }
    
    static func == (lhs: CarSearchOptionItem, rhs: CarSearchOptionItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
