//
//  GV.swift
//  comfi
//
//  Created by Brian Li on 10/13/18.
//

import Foundation

struct GV {
    static var me: User = User()
    static var friends: [User] = []
    
    struct Plaid {
        static var account_id: String!
        static var public_token: String!
    }
    
    struct Backend {
        static let server: String = "http://localhost:3000"
        static let username: String = "hackdukeisawesome"
        static let password: String = "Lm8Rsp5+$~m*M}D"
    }
    
    struct HomeScreen {
        static var pieChartDict: [String: [String: Any]] = [:]
    }
    
    struct GroupScreen {
        static var categories: [String]!
        static var competitorData: [String: [[String: Any]]] = [:]
        static var pieChartDict: [String: Double] = [:]
    }
}
