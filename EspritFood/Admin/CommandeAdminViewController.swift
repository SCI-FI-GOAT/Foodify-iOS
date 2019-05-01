//
//  CommandeAdminViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class CommandeAdminViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var commandeArray : NSArray = []

    @IBOutlet weak var listeCommandes: UITableView!
    //Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCommandeData()
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commandeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligneCmd", for: indexPath)
        
        let content = cell.viewWithTag(0)
        
        let LBLid = content?.viewWithTag(1) as! UILabel
        let LBLdate = content?.viewWithTag(2) as! UILabel
        let LBLuser = content?.viewWithTag(3) as! UILabel
        let LBLetat = content?.viewWithTag(4) as! UILabel
        
        
        
        let cmdDict = commandeArray[indexPath.row] as! Dictionary<String,String>
        
        
        LBLid.text = cmdDict["id_commandeP"]
        LBLdate.text = cmdDict["date_commandeP"]
        LBLuser.text = cmdDict["user_commandeP"]
        LBLetat.text = cmdDict["etat_commandeP"]
        
        switch LBLetat.text {
        case "En cours":
            LBLetat.textColor = hexStringToUIColor(hex: "E9EA9D")
        case "Annulee":
            LBLetat.textColor = hexStringToUIColor(hex: "EE1200") 
        case "Traitee":
            LBLetat.textColor = hexStringToUIColor(hex: "00B816")
        default:
            LBLetat.textColor = UIColor.yellow
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommandeDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommandeDetail" {
            let indexPath = sender as! IndexPath
            let DVC = segue.destination as! SousCommandeAdminViewController
            let idCmdDict = commandeArray[indexPath.row] as! Dictionary<String,String>
            DVC.idCommande = idCmdDict["id_commandeP"]!
            
            
            
        }
    }
    
    
    func getCommandeData(){
        let url4 : String = IP.init().url+"ListeCommandeAdmin.php"
        Alamofire.request(url4, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeCommandeAdmin.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.commandeArray = results
                
                self.listeCommandes.reloadData()
                
                
            }
            else {
                print("Call ListeCommandeAdmin.php failed! Erreur :", response.result.error!)
                
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Commande", image: UIImage(named: "icon-cart"), tag: 4)
        self.viewDidLoad()
    }
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
