//
//  AppEnvironment.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//


final class AppEnvironment {
    enum Status {
        case dev, real
    }
    
    static let shared = AppEnvironment()
    
    var status: Status = .dev
}

extension AppEnvironment {
    
    func dataSource() -> CarServiceDataSourceInterface {
        switch status {
        case .dev : return CarServiceDummyDataSource()
        case .real: return CarServiceRealDataSource()
        }
    }
    
}
