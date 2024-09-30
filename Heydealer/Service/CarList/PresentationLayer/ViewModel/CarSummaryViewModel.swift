//
//  CarSummaryViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

class CarSummaryViewModel: Hashable {
    let identifier: Int
    let data      : CarSummary
    
    init(identifier: Int, data: CarSummary) {
        self.identifier = identifier
        self.data       = data
    }
}

extension CarSummaryViewModel {
    
    static func == (lhs: CarSummaryViewModel, rhs: CarSummaryViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
