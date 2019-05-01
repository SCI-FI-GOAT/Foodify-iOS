//
//  PannierViewController.swift
//  EspritFood
//
//  Created by user on 14/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage
import Alamofire

class PannierViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableViewPannier: UITableView!
    
    @IBOutlet weak var txtAdresse: UITextField!
    @IBOutlet weak var total: UILabel!
    var panier : [NSManagedObject] = []
    var somme : Double = 0
    var dict:[Dictionary<String,String>] = []
    
    
    
    var isLoadingViewController = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
        viewLoadSetup()
        print("View Did Load")
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return panier.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligne")
        let contentview = cell?.viewWithTag(0)
        let qte = contentview?.viewWithTag(4) as! UILabel
        let prix = contentview?.viewWithTag(3) as! UILabel
        let libelle = contentview?.viewWithTag(2) as! UILabel
        let imageFood = contentview?.viewWithTag(1) as! UIImageView
        
        qte.text = panier[indexPath.row].value(forKey: "quantite") as! String
        qte.text = "Quantité : " + qte.text!
        
        prix.text = panier[indexPath.row].value(forKey: "prixUnitaire") as! String
        prix.text = "Prix Unitaire : " + prix.text! + " DT"
        /*
        somme = somme + Double(panier[indexPath.row].value(forKey: "quantite") as! String)!*Double(panier[indexPath.row].value(forKey: "prixUnitaire") as! String)!
        total.text = "Prix Total = " + String(somme)
        */
        libelle.text = panier[indexPath.row].value(forKey: "libelle") as! String
        
        var urls : String = panier[indexPath.row].value(forKey: "img") as! String

        imageFood.af_setImage(withURL: URL(string: urls)!)

        
        return cell!
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let persistanceContainer = appDelegate.persistentContainer
            let managedContext = persistanceContainer.viewContext
            
            managedContext.delete(panier[indexPath.row])
            
            
            do{
                try managedContext.save()
                panier.remove(at: indexPath.row)
                somme = 0 
                tableView.reloadData()
            }
            catch let nsError as NSError {
                print(nsError.userInfo)
            }
            
            
            let alert = UIAlertController(title:"Succés",message:"Article retiré du panier",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            
            viewWillAppear(true)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
     
        
        
        super.viewWillAppear(animated)
        
           txtAdresse.text = ""
        
        
        if isLoadingViewController {
            isLoadingViewController = false
        } else {
            viewLoadSetup()
            tableViewPannier.reloadData()
            txtAdresse.text = ""
            print("View Will Appear")
        }
        if (panier.count > 0){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        
            
            
            for i in 0 ... self.panier.count - 1 {
                self.somme = self.somme + Double(self.panier[i].value(forKey: "prixUnitaire") as! String)! * Double(self.panier[i].value(forKey: "quantite") as! String)!
         }
         
            self.total.text = "Prix total : " + String(self.somme) + " DT"
        }
        }
        if (panier.count == 0 ){
            self.total.text = "Prix total : 0 DT. Votre panier est vide."
        }
        
    }
    
    
    func viewLoadSetup(){
        somme = 0 
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let managedContext = persistanceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
        
        do {
            try panier = managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
           
            
        } catch  {
            let nsError = error as NSError
            print(nsError.userInfo)
        }
        
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Pannier", image: UIImage(named: "icon-cart"), tag: 3)
        self.viewDidLoad()
    }

    @IBAction func btnPasserCmd(_ sender: Any) {
        
        if((txtAdresse.text!.isEmpty)) {
            let alert = UIAlertController(title:"Erreur",message:"Remplissez le champs 'Adresse' s'il vous plaît",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        
        if(panier.count == 0) {
            let alert = UIAlertController(title:"Erreur",message:"Vous n'avez aucun article dans votre panier",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        

        for i in 0 ... panier.count-1 {
            
            dict.append(
                ["adresse"+String(i):txtAdresse.text!,
                 "quantite"+String(i):(panier[i].value(forKey: "quantite" ) as! String),
                 "libelleCommande"+String(i):(panier[i].value(forKey: "libelle" ) as! String),
                 "nb"+String(i):String (panier.count),
                 "username"+String(i):AppDelegate.usermail
                 
                ])
            
        }
        
        var p:Parameters = [:]
        
        for i in 0...dict.count-1 {
            for (key,value) in dict[i]{
                p.updateValue(value,forKey: key)
            }
        }
        print(p)
        
        // Call EnvoyerCommande.php
        let url3 : String = IP.init().url+"EnvoyerCommande.php"
        Alamofire.request(url3, method: .post, parameters: p).responseString {
            (response) in
            switch response.result {
            case .success:
                print("SUCCESS1")
                
                break
            case .failure(let error):
                
                print("SUCCESS2")
            }
        }

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let managedContext = persistanceContainer.viewContext
        
        
        for i in 0 ..< panier.count{
            
            managedContext.delete(panier[0])
            
            
            do{
                try managedContext.save()
                panier.remove(at: 0)
                somme = 0
            }
            catch let nsError as NSError {
                print(nsError.userInfo)
            }
            
        }

        let alert = UIAlertController(title:"Succés",message:"Commande envoyée avec succés",preferredStyle: .alert)
        let ok = UIAlertAction(title:"OK", style: .cancel)
        alert.addAction(ok)
        
        self.present(alert, animated:true ,completion: nil)
        
        viewWillAppear(true)

    }
    
}
