//
//  Date+Add.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

extension Date {
    
    func addDay(_ day: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: day, to: self)
    }
    
}
