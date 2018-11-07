//
//  NetworkManager.swift
//  comfi
//
//  Created by Brian Li on 10/14/18.
//

import Foundation

class NetworkManager {
    // MARK: - Singleton Instance
    static var sharedInstance: NetworkManager = NetworkManager()
    
    func testServerConnection() {
        
        let headers = [
            "Authorization": "Basic aGFja2R1a2Vpc2F3ZXNvbWU6TG04UnNwNSskfm0qTX1E",
            "Cache-Control": "no-cache",
            "Postman-Token": "db3c561c-8ccc-4322-8eec-399bdff66097"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: GV.Backend.server)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                do {
                    
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let dictionary = jsonData as? [String: Any] {
                        print(dictionary)
                    }
                    
                } catch _ {
                    
                }
                
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
    
    func obtainPlaidData(fbid: String, public_token: String, account_id: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache",
            "Postman-Token": "a010107f-b800-4332-9579-e9ca64447c4d"
        ]

        let postData = NSMutableData(data: fbid.data(using: String.Encoding.utf8)!)
        postData.append("&public_token=\(public_token)".data(using: String.Encoding.utf8)!)
        postData.append("&account_id=\(account_id)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: GV.Backend.server + "/plaid")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            } else {

                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let dictionary = jsonData as? [String: Any] {
                        print("returned data")
                        print(dictionary)
                    }
                    
                } catch _ {
                    
                }
                
                print("response was")
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            
            completionHandler(true)
        })
        
        dataTask.resume()
    }
    
    func obtainHomeScreenData(completionHandler: @escaping (_ success: Bool) -> Void) {
        print("\n\n\nhome screen data fetch")
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic aGFja2R1a2Vpc2F3ZXNvbWU6TG04UnNwNSskfm0qTX1E",
            "Cache-Control": "no-cache",
            "Postman-Token": "86848f4c-7f5b-4220-bd50-7913f7614f9a"
        ]
        
        let postData = NSMutableData(data: "fbid=\(GV.me.fbid!)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: GV.Backend.server + "/home")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let dictionary = jsonData as? [String: Any] {
                       /*
                        if let val = dictionary["account_balance"] {
                            print("looking for account balance \(val)")
                            
                            GV.me.current_balance = Double(s)
                        }
 */
                        GV.me.current_balance = dictionary["account_balance"]! as? String
                        GV.me.monthly_saving = dictionary["monthly_saving"]! as? String
                        
                        if let predictions = dictionary["predictions"] as? [String: String] {
                            GV.HomeScreen.predictedSavings = predictions["saving"] as? String
                            GV.HomeScreen.predictedSpending = predictions["spending"] as? String
                        }
                        
                        if let pieChartData = dictionary["pie_graph"] as? [[String: Any]] {
                            for slice in pieChartData {
                                
                                if let slice = slice as? [String: Any] {
                                    var category = slice["category"] as! String
                                    var sliceDataDict: [String: Any] = [:]
                                    sliceDataDict["percent"] = slice["percent"] as? Double
                                    sliceDataDict["amount"] = slice["amount"] as? Double
                                    GV.HomeScreen.pieChartDict[category] = sliceDataDict
                                    print("cateogyr will follow\n")
                                    print(GV.HomeScreen.pieChartDict[category])
                                }
                            }
                        }
                        
                        if let transactionData = dictionary["transactions"] as? [[String: Any]] {
                            for eachTransaction in transactionData {
                                var transaction = Transaction()
                                transaction.name = eachTransaction["name"] as? String
                                transaction.amount = eachTransaction["amount"]! as? String
                                transaction.date = eachTransaction["date"] as? String
                                GV.me.transactions.append(transaction)
                            }
                        }
                    }
                    
                } catch _ {
                    
                }
                
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            
            completionHandler(true)
        })
        
        dataTask.resume()
    }
    
    func obtainGroupScreenData(public_token: String, completionHandler: @escaping (_ success: Bool) -> Void) {

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic aGFja2R1a2Vpc2F3ZXNvbWU6TG04UnNwNSskfm0qTX1E",
            "Cache-Control": "no-cache",
            "Postman-Token": "3b47d698-cd5c-4fcb-818f-923a28e044ca"
        ]
        
        let postData = NSMutableData(data: "fbid=\(GV.me.fbid!)".data(using: String.Encoding.utf8)!)
        postData.append("&public_token=\(public_token)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: GV.Backend.server + "/group")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                
                print("group data was returned")
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let dictionary = jsonData as? [String: Any] {
                        
                        if let categories = dictionary["categories"] as? [String] {
                            GV.GroupScreen.categories = categories
                        }
                        
                        
                        if let categoryPercents = dictionary["categoryPercents"] as? [String: Any] {
                            print("the length of categories is \(GV.GroupScreen.categories)")
                            
                            for category in GV.GroupScreen.categories {
                                var categoryDataDict: [[String: Any]] = []
                                if let categoryData = categoryPercents[category] as? [Any] {
                                    print("datadict has 0")
                                    for categoryCompetitorData in categoryData {
                                        print("datadict has 1")
                                        if let categoryCompetitorData = categoryCompetitorData as? [String: Any]  {
                                            categoryDataDict.append(["fbid": categoryCompetitorData["fbid"] as! String, "value": categoryCompetitorData["percent"] as! Double])
                                           
                                            print("datadict has \(categoryDataDict.count)")
                                        }
                                    }
                                }
                                
                                GV.GroupScreen.competitorData[category] = categoryDataDict
                            }
                        }
                        
                        if let pieChartData = dictionary["pie_graph"] as? [Any] {
                            print("the pie chart was accessed")
                            for slice in pieChartData {
                                if let slice = slice as? [String: Any] {
                                    GV.GroupScreen.pieChartDict[slice["category"] as! String] = slice["percent"] as? Double
                                }
                            }
                        }
                    }
                    
                } catch _ {
                    
                }
                
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            
            completionHandler(true)
        })
        
        dataTask.resume()
    }
    
    
    func obtainStrengthsAndWeaknesses(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        print("\n\n\nattempting to obtain strengths and weaknesses")
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic aGFja2R1a2Vpc2F3ZXNvbWU6TG04UnNwNSskfm0qTX1E",
            "Cache-Control": "no-cache",
            "Postman-Token": "3b47d698-cd5c-4fcb-818f-923a28e044ca"
        ]
        
        let postData = NSMutableData(data: "fbid=\(GV.me.fbid!)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: GV.Backend.server + "/community")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                
            } else {
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)

                    if let dictionary = jsonData as? [String: Any] {
                        GV.LearnScreen.strengths = dictionary["strengths"] as! [String]
                        GV.LearnScreen.weaknesses = dictionary["weaknesses"] as! [String]

                        if let selfCanHelp = dictionary["self_can_help"] as? [Any] {
                            for person in selfCanHelp as! [[String: Any]] {
                                var personDict: [String: Any] = [:]
                                personDict["categories"] = person["categories"] as! [String]
                                personDict["fbid"] = person["fbid"] as! String
                                GV.LearnScreen.canHelp.append(personDict)
                            }
                        }
                        
                        // set the getHelp for the CommunityScreen
                        if let selfGetHelp = dictionary["self_gets_help"] as? [Any] {
                            for person in selfGetHelp as! [[String: Any]] {
                                var personDict: [String: Any] = [:]
                                personDict["categories"] = person["categories"] as! [String]
                                personDict["fbid"] = person["fbid"] as! String
                                GV.LearnScreen.getHelp.append(personDict)
                            }
                        }
                    }
                    
                } catch _ {
                    
                }
            }
            
            completionHandler(true)
        })
        
        dataTask.resume()
    }
}
