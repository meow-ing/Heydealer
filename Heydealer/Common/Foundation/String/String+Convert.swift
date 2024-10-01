//
//  String+Convert.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//
import Foundation

extension String {
    
    func date(format: String = "yyyyMMddHHmmss") -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
    
}
