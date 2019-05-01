//
//  SousCommandeAdminViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SousCommandeAdminViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableViewSousCommande: UITableView!
    
    var CommandeArray: NSArray = []
    
    var idCommande:String = ""
    
    @IBOutlet weak var numCmd: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var adresse: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCommandeDetails()

        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_valider(_ sender: Any) {
        
        decision(etat: "Traitee", id: idCommande)
        
        let alert = UIAlertController(title:"Succés",message:"Commande acceptée",preferredStyle: .alert)
        let ok = UIAlertAction(title:"OK", style: .cancel)
        alert.addAction(ok)
        
        self.present(alert, animated:true ,completion: nil)
        
    }
    
    @IBAction func btn_rejeter(_ sender: Any) {
        
        decision(etat: "Annulee", id: idCommande)
        
        let alert = UIAlertController(title:"Succés",message:"Commande annulée",preferredStyle: .alert)
        let ok = UIAlertAction(title:"OK", style: .cancel)
        alert.addAction(ok)
        
        self.present(alert, animated:true ,completion: nil)
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
        
        let commandeDict = CommandeArray[indexPath.row] as! Dictionary<String,String>
        
        let urls:String = IP.init().url+"images/"+commandeDict["image"]!
        imageView.af_setImage(withURL: URL(string: urls)!)
        
        labelLibelle.text=commandeDict["libelle_commande"]
        labelQuantite.text="Quantité : " + commandeDict["quantite"]!
        
        
        return cell!
    }
    
    
    
    @IBAction func retour(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getCommandeDetails(){
        // Call ListeOffreClient.php
        let url3 : String = IP.init().url+"ListeSousCommandeUser.php?id_commandeP="+idCommande
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeSousCommandeUser.php is sucess!")
                let results = response.result.value as! NSArray
                print(results)
                self.CommandeArray = results
                
                let commandeDict = self.CommandeArray[0] as! Dictionary<String,String>

        
                self.numCmd.text = "Détails de la commande N° " + self.idCommande
                self.username.text = "Username : " + commandeDict["username"]!
                self.date.text = "Le " + commandeDict["date"]!
                self.adresse.text = "Adresse : " + commandeDict["adresse"]!
                
                self.tableViewSousCommande.reloadData()
                
                
            }
            else {
                print("Call ListeSousCommandeUser.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    func decision(etat : String, id : String) {
        //UPDATE
        let urlInsert = IP.init().url+"TraiterCommande.php"
        let params : Parameters = [
            "etat":etat,
            "id_commande":id
        ]
        
        Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                print("Success 1")
                break
            case .failure(let error):
                
                print("Success 2")
                
            }
        })
    }
    
    

}
