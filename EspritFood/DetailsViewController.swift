//
//  DetailsViewController.swift
//  EspritFood
//
//  Created by user on 14/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import CoreData

class DetailsViewController: UIViewController {
    
    var myLib:String = ""
    var imgFood:String = ""
    var descriptionFood:String = ""
    var prix:String = ""
    var remiseFood:String = ""
    
    var test:Int?

    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var libelleFood: UILabel!
    @IBOutlet weak var descFood: UILabel!
    @IBOutlet weak var prixFood: UILabel!
    @IBOutlet weak var qteFood: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


        
        libelleFood.text = myLib
        descFood.text = descriptionFood
        prixFood.text = "Prix = "+remiseFood+" DT"

        
        let urls:String = IP.init().url+"images/"+imgFood
        imageFood.af_setImage(withURL: URL(string: urls)!)
        
        
       
    }
    

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func btnPlus(_ sender: Any) {
        var qte:Int
        qte = Int(qteFood.text!)!
        qte = qte + 1
        qteFood.text = String(qte)
    }
    
   
    @IBAction func btnMoins(_ sender: Any) {
        var qte:Int
        qte = Int(qteFood.text!)!
        if (qte > 1){
        
        qte = qte - 1
        qteFood.text = String(qte)
        }
    }
    
    @IBAction func btnAjouter(_ sender: Any) {
        test = -1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistanceContainer = appDelegate.persistentContainer
        let managedContext = persistanceContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Panier")
        fetchRequest.predicate = NSPredicate(format: "img = %@",IP.init().url+"images/"+imgFood )
        
        
        do {
            try  test = managedContext.fetch(fetchRequest).count
            
            
        } catch  {
            
            let nsError = error as NSError
            print(nsError.userInfo)
        }
        
        if test == 0 {
            let entity = NSEntityDescription.entity(forEntityName: "Panier", in: managedContext)
            
            
            let panier = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            panier.setValue(IP.init().url+"images/"+imgFood, forKey: "img")
            panier.setValue(myLib, forKey: "libelle")
            panier.setValue(qteFood.text, forKey: "quantite")
            panier.setValue(remiseFood, forKey: "prixUnitaire")

            do {
                try managedContext.save()
                
                let alert = UIAlertController(title:"Succés",message:"Produit ajouté au panier",preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
                
            } catch  {
                let nsError = error as NSError
                print(nsError.userInfo)
            }
        } else {
           
          
            do {
                let panier = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
                
                
            
            panier.setValue(IP.init().url+"images/"+imgFood, forKey: "img")
            panier.setValue(myLib, forKey: "libelle")

                var qteN : Int = 0
                qteN = Int ((try managedContext.fetch(fetchRequest)[0] as AnyObject).value(forKey: "quantite") as! String)! + Int(qteFood.text!)!
                
            panier.setValue(String(qteN), forKey: "quantite")
            panier.setValue(remiseFood, forKey: "prixUnitaire")
            }
            catch  {
                let nsError = error as NSError
                print(nsError.userInfo)
            }
            
            do {
                try managedContext.save()
                
                let alert = UIAlertController(title:"Succés",message:"Quantité mise à jour",preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
                
            } catch  {
                let nsError = error as NSError
                print(nsError.userInfo)
            }

            
            
        }
        
        
        
    }
    
}
