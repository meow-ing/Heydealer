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

// MARK: display
extension CarSummaryViewModel {
    
    func summary() -> String {
        [year(), mileage(), area()].joined(separator: "‧")
    }
    
    func name() -> String {
        data.info.name
    }
    
    func year() -> String {
        String(localized: "\(data.info.year)년")
    }
    
    func mileage() -> String {
        let mileage   = data.info.mileage
        let unit10000 = mileage / 10000
        let unit1000  = (mileage / 1000) - (unit10000 * 10)
        let unit100   = mileage % 1000
        
        let text = [(unit10000, String(localized: "만")), (unit1000, String(localized: "천")), (unit100, "")].reduce("") { partialResult, unit in
            guard unit.0 > 0 else { return partialResult }
            
            return partialResult.appending("\(0)\(unit.1)")
        }
        
        return (text.count == 0 ? "" : text).appending("km")
    }
    
    func area() -> String {
        data.info.area
    }
}

// MARK: Hashable
extension CarSummaryViewModel {
    
    static func == (lhs: CarSummaryViewModel, rhs: CarSummaryViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
