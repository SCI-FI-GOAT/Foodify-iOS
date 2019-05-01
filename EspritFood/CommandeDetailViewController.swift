//
//  CommandeDetailViewController.swift
//  EspritFood
//
//  Created by user on 23/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CommandeDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var CommandeArray: NSArray = []
    var idCommande : String?
    var dateCommande : String?
    
    @IBOutlet weak var labelNumCommande: UILabel!
    @IBOutlet weak var labelDateCommande: UILabel!
    @IBOutlet weak var tableViewCmdDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCommandeDetails()
        labelNumCommande.text = "Commande N° "+idCommande!
        labelDateCommande.text = "Date "+dateCommande!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommandeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article")
        let contentView = cell?.viewWithTag(0)
        let imageView = contentView?.viewWithTag(1) as! UIImageView
        let labelLibelle = contentView?.viewWithTag(2) as! UILabel
        let labelQuantite = contentView?.viewWithTag(3) as! UILabel
        let labelAdresse = contentView?.viewWithTag(4) as! UILabel
        
        let commandeDict = CommandeArray[indexPath.row] as! Dictionary<String,String>
        
        let urls:String = IP.init().url+"images/"+commandeDict["image"]!
        imageView.af_setImage(withURL: URL(string: urls)!)
        
        labelLibelle.text=commandeDict["libelle_commande"]
        labelQuantite.text="Quantité : " + commandeDict["quantite"]!
        labelAdresse.text="Adresse : " + commandeDict["adresse"]!
        
        
        return cell!
    }
    
    func getCommandeDetails(){
        // Call ListeOffreClient.php
        let url3 : String = IP.init().url+"ListeSousCommandeUser.php?id_commandeP="+idCommande!
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeSousCommandeUser.php is sucess!")
                let results = response.result.value as! NSArray
                print(results)
                self.CommandeArray = results
                self.tableViewCmdDetails.reloadData()
            }
            else {
                print("Call ListeSousCommandeUser.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
