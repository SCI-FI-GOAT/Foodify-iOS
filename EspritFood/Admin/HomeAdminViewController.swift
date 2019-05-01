//
//  HomeAdminViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class HomeAdminViewController: UIViewController {

    @IBOutlet weak var nbCmdEnCours: UILabel!
    @IBOutlet weak var nbCmdTraitees: UILabel!
    @IBOutlet weak var nbCMDAnnulees: UILabel!
    
    
    @IBOutlet weak var nbDashUser: UILabel!
    @IBOutlet weak var nbDashCmd: UILabel!
    @IBOutlet weak var nbDashOffre: UILabel!
    @IBOutlet weak var nbDashRestau: UILabel!
    
    
    var topArray : NSArray = []
    var dashArray : NSArray = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDashTop()
        getDashBottom()
    }

    

    func getDashTop(){
        
        // Call CommandeDash.php
        let url3 : String = IP.init().url+"CommandeDash.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call CommandeDash.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.topArray = results
                
                
                let cmdDict = self.topArray[0] as! Dictionary<String,String>
                self.nbCmdEnCours.text = cmdDict["EnCours"]
                self.nbCmdTraitees.text = cmdDict["Traitee"]
                self.nbCMDAnnulees.text = cmdDict["Annulee"]
                
            }
            else {
                print("Call CommandeDash.php failed! Erreur :", response.result.error!)
            }
        }
        
        
    }
    
    
    func getDashBottom(){
        
        // Call DashTopAdmin.php
        let url3 : String = IP.init().url+"DashTopAdmin.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call DashTopAdmin.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.dashArray = results
                let dashDict = self.dashArray[0] as! Dictionary<String,String>
                self.nbDashUser.text = dashDict["users"]
                self.nbDashCmd.text = dashDict["commandes"]
                self.nbDashOffre.text = dashDict["offres"]
                self.nbDashRestau.text = dashDict["restaurants"]

            }
            else {
                print("Call DashTopAdmin.php failed! Erreur :", response.result.error!)
            }
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Accueil", image: UIImage(named: "icon-home2"), tag: 1)
    }

}
