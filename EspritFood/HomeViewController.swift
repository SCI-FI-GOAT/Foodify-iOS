//
//  HomeViewController.swift
//  EspritFood
//
//  Created by user on 10/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , UITableViewDataSource, UITableViewDelegate{
   
        
    @IBOutlet weak var dash: UITableView!
    let image = ["1","2","3","4","5","6","7"]
    
    var commandeArray:NSArray = []
    var top5Array:NSArray = []
    var promosArray:NSArray = []
    var recommandedArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Home")
        getCommandeData()
        getTOP5Data()
        getOffresData()
        getRecommandedData()
        print("CURRENT USER ",AppDelegate.usermail)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
            
        case 99:
            if commandeArray.count == 0 {
                return 1
            } else {
                return commandeArray.count
            }
        case 100:
           return top5Array.count
        case 101:
            return promosArray.count
        case 102:
            return recommandedArray.count
        default:
            return 1 //commandeArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
        
        switch collectionView.tag {
        case 99:
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            let imageview = cell!.viewWithTag(1) as! UIImageView
            
            
            print("CELL 99")
            
            if commandeArray.count == 0 {
                let numCommande = cell!.viewWithTag(2) as! UILabel
                let dateCommande = cell!.viewWithTag(3) as! UILabel
                let etatCommande = cell!.viewWithTag(4) as! UILabel
                numCommande.text = "Votre liste"
                dateCommande.text = "est"
                etatCommande.text = "Vide !"
                imageview.image = UIImage(named: "image-pannier2")
                
            } else {
                let resultDict = commandeArray[indexPath.item] as! Dictionary<String,String>
                
                if resultDict["etat_commandeP"]! == "En cours" {
                    imageview.image = UIImage(named: "commande-attente")
                }
                if resultDict["etat_commandeP"]! == "Traitee" {
                    imageview.image = UIImage(named: "commande-ok")
                }
                if resultDict["etat_commandeP"]! == "Annulee" {
                    imageview.image = UIImage(named: "commande-refus")
                }
                
                let numCommande = cell!.viewWithTag(2) as! UILabel
                let dateCommande = cell!.viewWithTag(3) as! UILabel
                let etatCommande = cell!.viewWithTag(4) as! UILabel
                
                numCommande.text = "Commande N° " + resultDict["id_commandeP"]!
                dateCommande.text = resultDict["date_commandeP"]
                etatCommande.text = resultDict["etat_commandeP"]
            }


            
        case 100:
            print("CELL 100")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            
            let imageview = cell!.viewWithTag(1) as! UIImageView
            let libelle = cell!.viewWithTag(2) as! UILabel
            let ratio = cell!.viewWithTag(3) as! UILabel
            
            let resultDict = top5Array[indexPath.item] as! Dictionary<String,String>
            
            libelle.text = resultDict["libelleTOP"]
            ratio.text = resultDict["RatioTOP"]! + " %"
            
            let urls:String = IP.init().url+"images/"+resultDict["imageTOP"]!
            imageview.af_setImage(withURL: URL(string: urls)!)

        case 101:
            print("CELL 101")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath)
            
            let imageview = cell!.viewWithTag(1) as! UIImageView
            let libelle = cell!.viewWithTag(2) as! UILabel
            let ratio = cell!.viewWithTag(3) as! UILabel
            
            let resultDict = promosArray[indexPath.item] as! Dictionary<String,String>
            
            libelle.text = resultDict["libelle_food"]
            ratio.text = "- " + String(resultDict["taux"]!) + " %"
            
            let urls:String = IP.init().url+"images/"+resultDict["image"]!
            imageview.af_setImage(withURL: URL(string: urls)!)
            
        case 102:
            print("CELL 102")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell4", for: indexPath)

            if recommandedArray.count == 0 {
                cell?.isHidden = true
                
            } else {
                let imageview = cell!.viewWithTag(1) as! UIImageView
                let libelle = cell!.viewWithTag(2) as! UILabel
                
                let resultDict = recommandedArray[indexPath.item] as! Dictionary<String,String>
                
                libelle.text = resultDict["libelleTOP"]
                let urls:String = IP.init().url+"images/"+resultDict["imageTOP"]!
                imageview.af_setImage(withURL: URL(string: urls)!)
            }
            
       
        
        default:
            print("Default")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            
            let imageview = cell!.viewWithTag(1) as! UIImageView
            
            imageview.image = UIImage(named: image[indexPath.row])
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var nbrrows : Int?
        
        switch section {
        case 0:
            nbrrows=1
        case 1:
            nbrrows=1
        case 2:
            nbrrows=1
        case 3:
            nbrrows=1
        default:
            nbrrows=1
        }
        
        
        return nbrrows!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype1")
            //let content = cell?.viewWithTag(0)
            let commande = cell!.viewWithTag(99) as! UICollectionView
            commande.reloadData()
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype2")
            let top5 = cell!.viewWithTag(100) as! UICollectionView
            top5.reloadData()
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype3")
            let promos = cell!.viewWithTag(101) as! UICollectionView
            promos.reloadData()
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype4")
            if recommandedArray.count == 0 {
                cell?.isHidden = true
                } else {
                let recommanded = cell!.viewWithTag(102) as! UICollectionView
                recommanded.reloadData()
            }
           
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "prototype1")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell : UICollectionViewCell?
        
        if collectionView.tag == 99 {
            
            if(commandeArray.count == 0){
                return
            }
            
            performSegue(withIdentifier: "goToCmdDetails", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCmdDetails"{
            
            let index = sender as! IndexPath
            let DVC = segue.destination as! CommandeDetailViewController
            let commandeDict = commandeArray[index.row] as! Dictionary<String,String>
            
            DVC.idCommande = commandeDict["id_commandeP"]
            DVC.dateCommande = commandeDict["date_commandeP"]
            
        }
    }
    
    func getCommandeData(){
        let url4 : String = IP.init().url+"ListeCommandeUser.php?username="+AppDelegate.usermail
        Alamofire.request(url4, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeCommandeUser.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.commandeArray = results
                print("WEBSERVICE : " ,self.commandeArray.count)
                
                
                var cell : UITableViewCell?
                cell = self.dash.dequeueReusableCell(withIdentifier: "prototype1")
                //let content = cell?.viewWithTag(0)
                let commande = cell!.viewWithTag(99) as! UICollectionView
                commande.reloadData()
                self.dash.reloadData()

            }
            else {
                print("Call ListeCommandeUser.php failed! Erreur :", response.result.error!)
                
            }
        }
    }
    
    func getTOP5Data(){
        // Call TOP5.php
        let url1 : String = IP.init().url+"TOP5.php"
        Alamofire.request(url1, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call TOP5.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.top5Array = results
                
                var cell : UITableViewCell?
                cell = self.dash.dequeueReusableCell(withIdentifier: "prototype2")
                //let content = cell?.viewWithTag(0)
                let top5 = cell!.viewWithTag(100) as! UICollectionView
                top5.reloadData()
                self.dash.reloadData()
            }
            else {
                print("Call TOP5.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    func getRecommandedData(){
        // Call Recommanded.php
        let url2 : String = IP.init().url+"Recommanded.php?username="+AppDelegate.usermail
        Alamofire.request(url2, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call Recommanded.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.recommandedArray = results
                
                var cell : UITableViewCell?
                cell = self.dash.dequeueReusableCell(withIdentifier: "prototype4")
                //let content = cell?.viewWithTag(0)
                let recommanded = cell!.viewWithTag(102) as! UICollectionView
                recommanded.reloadData()
                self.dash.reloadData()
            }
            else {
                print("Call Recommanded.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    func getOffresData(){
        // Call ListeOffreClient.php
        let url3 : String = IP.init().url+"ListeOffreClient.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeOffreClient.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.promosArray = results
  
                var cell : UITableViewCell?
                cell = self.dash.dequeueReusableCell(withIdentifier: "prototype3")
                //let content = cell?.viewWithTag(0)
                let promos = cell!.viewWithTag(101) as! UICollectionView
                promos.reloadData()
                self.dash.reloadData()
            }
            else {
                print("Call ListeOffreClient.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Accueil", image: UIImage(named: "icon-home3"), tag: 1)
    }


}
