//
//  FBLoginViewController.swift
//  comfi
//
//  Created by Brian Li on 10/13/18.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController {

    @IBOutlet var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureLoginButton()
        
    }
    
    func configureLoginButton() {
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FBLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error !=  nil) {
            
        } else if (result.isCancelled) {
            
        } else if let token = result.token {
    
            FBSDKAccessToken.setCurrent(token)
            
            if result.declinedPermissions.count == 0 {
                print(token.userID!)
                
                if FBSDKAccessToken.current().hasGranted("user_friends") {
                    // Prepare your request
                    let params = ["fields": "id, first_name, last_name, name, email, picture"]
                    let request = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params, httpMethod: "GET")
                    
                    // Make a call using request to get friend data
                    let _ = request?.start(completionHandler: { (connection, result, error) in
                        
                        print("Friends Result: \(String(describing: result))")
                        if let result = result as? [String: Any] {
                            for friend in result["data"] as! [Any] {
                                if let friend = friend as? [String: Any] {
                                    var fbFriend = User()
                                    fbFriend.first_name = friend["first_name"] as? String
                                    fbFriend.last_name = friend["last_name"] as? String
                                    fbFriend.fbid = friend["id"] as? String
                                    if let picture = friend["picture"] as? [String: Any] {
                                        if let pictureData = picture["data"] as? [String: Any] {
                                            fbFriend.profileURL = pictureData["url"] as? String
                                        }
                                    }
                                    
                                    GV.friends.append(fbFriend)
                                }
                                
                            }
                        }
                        
                        // present plaid login view controller
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PlaidViewController") as! ViewController
                        //self.present(controller, animated: true, completion: nil)
                        
                        let homePage = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(homePage, animated: true, completion: nil)
                    })
                }
            }
            
        } else {
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}
