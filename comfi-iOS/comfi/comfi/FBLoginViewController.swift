//
//  FBLoginViewController.swift
//  comfi
//
//  Created by Brian Li on 10/13/18.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let loginManager = FBSDKLoginManager()
    
    // MARK: Outlets
    @IBOutlet var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureLoginButton()
        
    }
    
    func configureLoginButton() {
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        // when in developer mode, logout on first launch if logged in
        if GV.isDeveloperMode {
            loginManager.logOut()
        }
        
        
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
            
            GV.me.fbid = token.userID
            
            // TODO: prevent proceeding if problem
            getUserData(GV.me.fbid) { (success) in
                if(success) {
                    // add the current user to the friends list
                    GV.friends.append(GV.me)
                    
                } else {
                    
                }
            }
            
            if result.declinedPermissions.count == 0 {
                //print(token.userID!)
                
                if FBSDKAccessToken.current().hasGranted("user_friends") {
                    retrieveFriends { (success) in
                        if(success) {
                            
                        } else {
                            
                        }
                    }
                }
            }
            
            // test connection to comFi server
            //NetworkManager.sharedInstance.testServerConnection()
            
            // present plaid login view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PlaidViewController") as! ViewController
            self.present(controller, animated: true, completion: nil)
            
            let homePage = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            //self.present(homePage, animated: true, completion: nil)
            
        } else {
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}

// MARK: Facebook Graph API Network Manager
extension FBLoginViewController {
    
    /*
     * method to retrieve basic text info for the user
     */
    func getUserData(_ userID: String, getUserDataCompletionHandler: @escaping (_ success: Bool) -> Void) -> Void {
   
        FBSDKGraphRequest(graphPath: userID, parameters: ["fields": "first_name, last_name, name, email, picture.type(large)"]).start(
            completionHandler: {(connection, result, error) -> Void in
                
                if let result = result as? [String: Any] {
                    
                    GV.me.first_name = result["first_name"] as? String
                    GV.me.last_name = result["last_name"] as? String
                    
                    if let picture = result["picture"] as? [String: Any] {
                        if let pictureData = picture["data"] as? [String: Any] {
                            GV.me.profileURL = pictureData["url"] as? String
                            let profilePhotoData = NSData(contentsOf: URL(string: GV.me.profileURL!)!)
                            let profilePhoto = UIImage(data: profilePhotoData! as Data)
                            GV.me.profilePhoto = profilePhoto
                        }
                    }

                    getUserDataCompletionHandler(true)
                } else {
                    getUserDataCompletionHandler(false)
                }
        })
    }
    
    /*
     * method to retrieve basic text info for user's facebook friends
     */
    func retrieveFriends(retrieveFriendsCompletionHandler: @escaping (_ success: Bool) -> Void) {
        
        // Prepare your request
        let params = ["fields": "id, first_name, last_name, name, email, picture"]
        let request = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params, httpMethod: "GET")
        
        // Make a call using request to get friend data
        let _ = request?.start(completionHandler: { (connection, result, error) in
            //print("Friends Result: \(String(describing: result))")
            
            // if there was an error, completion with failure
            if(error != nil) {
                retrieveFriendsCompletionHandler(false)
            }
            
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
                                let profilePhotoData = NSData(contentsOf: URL(string: fbFriend.profileURL!)!)
                                let profilePhoto = UIImage(data: profilePhotoData! as Data)
                                fbFriend.profilePhoto = profilePhoto
                            }
                        }
                        
                        GV.friends.append(fbFriend)
                    }
                }
                
                // completion with success
                retrieveFriendsCompletionHandler(true)
            } else {
                // request result could not be read, completion with failure
                retrieveFriendsCompletionHandler(false)
            }
        })
    }
    
    /*
    func retrieveProfilePhoto(_ userID: String, retrieveProfilePhotoCompletionHandler: @escaping (_ success: Bool) -> Void) {
        let params = ["height": "100"]
        print("the user id is \(userID)")
        var request = FBSDKGraphRequest(graphPath: "/\(userID)/picture", parameters: nil, httpMethod: "GET")
        request?.start(completionHandler: { connection, result, error in
            print("the photo result is")
            dump(result)
            retrieveProfilePhotoCompletionHandler(true)
        })
    }
    */
}
