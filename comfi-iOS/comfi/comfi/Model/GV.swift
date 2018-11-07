//
//  GV.swift
//  comfi
//
//  Created by Brian Li on 10/13/18.
//

import Foundation

struct GV {
    static var isDeveloperMode: Bool = true
    
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
        static var predictedSavings: String!
        static var predictedSpending: String!
    }
    
    struct GroupScreen {
        static var categories: [String]!
        static var competitorData: [String: [[String: Any]]] = [:]
        static var pieChartDict: [String: Double] = [:]
    }
    
    struct LearnScreen {
        static var strengths: [String] = []
        static var weaknesses: [String] = []
        static var canHelp: [[String: Any]] = []
        static var getHelp: [[String: Any]] = []
    }
    
    static func getUser(fromID fbid: String) -> User? {
        for person in friends {
            if person.fbid == fbid {
                return person
            }
        }
        return nil
    }
}
