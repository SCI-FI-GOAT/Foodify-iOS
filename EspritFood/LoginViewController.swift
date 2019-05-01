//
//  LoginViewController.swift
//  EspritFood
//
//  Created by user on 10/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Alamofire
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate,GIDSignInUIDelegate{
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       /* let buttonFB = FBSDKLoginButton()
        buttonFB.delegate = self
        buttonFB.readPermissions = ["public_profile","email"]
        buttonFB.center = self.view.center
        self.view.addSubview(buttonFB)*/
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        if FBSDKAccessToken.current() != nil {
            print("Logged in!")
            
        } else {
            print("Not Logged in!")
        }

    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled {
            print("User Canceled Login")
        } else {
            // Successful Login
            print("User Login Successful !")
            //self.performSegue(withIdentifier: "goToHome", sender: loginButton)
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged out !")
    }
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
 

}
