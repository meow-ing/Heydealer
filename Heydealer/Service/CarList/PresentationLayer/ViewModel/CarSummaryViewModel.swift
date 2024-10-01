//
//  CarSummaryViewModel.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation
import UIKit
import Combine

class CarSummaryViewModel: Hashable {
    let identifier: String
    let data      : CarSummary
    
    @Published var autionStatus: (name: String, color: UIColor)?
        
    init(identifier: String, data: CarSummary) {
        self.identifier = identifier
        self.data       = data
        
        guard let aution = data.aution else { return }
        
        updateAutionStatus(aution.status)
    }
}

// MARK: display
extension CarSummaryViewModel {
    
    func autionTimeStamp() -> AnyPublisher<String?, Never>? {
        guard let aution = data.aution, aution.status == .approved, let date = aution.expireDate else { return nil }
        guard date.timeIntervalSinceNow > 0 else { return nil }
        
        return Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map({ [weak self] _ in
                let interval = date.timeIntervalSinceNow
                
                guard interval > 0 else {
                    self?.updateAutionStatus(.expired)
                    return nil
                }
                
                let time    = NSInteger(interval)
                let seconds = time % 60
                let minutes = (time / 60) % 60
                let hours   = (time / 3600)

                return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
            }).eraseToAnyPublisher()
        
    }
    
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
    
    private func updateAutionStatus(_ status: CarAutionStatus) {
        autionStatus = (status.name, status.color)
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
