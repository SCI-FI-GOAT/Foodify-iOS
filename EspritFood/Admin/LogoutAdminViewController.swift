//
//  LogoutAdminViewController.swift
//  EspritFood
//
//  Created by user on 17/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogoutAdminViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.signOut()
        //SEGUE LOGIN
        
        self.dismiss(animated: true, completion: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Logout", image: UIImage(named: "icon-logout"), tag: 6)
    }

}
