//
//  NetworkTest.swift
//  HeydealerTests
//
//  Created by 지윤 on 10/1/24.
//

import Testing
@testable import Heydealer

struct NetworkTest {

    @Test(.disabled("서버 403 에러 남"),
        arguments: [
        ["page" : "1"],
        ["page" : 1],
        ["page" : [0, 1, 2]]])
    func getMethodTest(param: [String : Any]?) async throws {
        let path = "/cars/"
        
        let _ = try await Network.request(path: path, httpMethod: .get, param: param, responseType: TestResponse.self)
    }

}

struct TestResponse: Decodable {
    
}
