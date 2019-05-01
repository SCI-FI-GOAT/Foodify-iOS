//
//  SousMenuViewController.swift
//  EspritFood
//
//  Created by user on 14/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//


import UIKit
import AlamofireImage
import Alamofire

class SousMenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var sousMenuArray : NSArray = []
    var myCat:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSousMenu()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sousMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SousMenu", for: indexPath)
        
        let content = cell.viewWithTag(0)
        
        let imageview = content?.viewWithTag(1) as! UIImageView
        let label = content?.viewWithTag(2) as! UILabel
         let labelPrix = content?.viewWithTag(3) as! UILabel
        let imagesDict = sousMenuArray[indexPath.row] as! Dictionary<String,String>
        
        label.text=imagesDict["libelleFood"]
        labelPrix.text="Prix : "+imagesDict["prixRemise"]!+" dt"
        let urls:String = IP.init().url+"images/"+imagesDict["imageFood"]!
        imageview.af_setImage(withURL: URL(string: urls)!)

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetails" , sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetails" {
            
            let DVC = segue.destination as! DetailsViewController
            let indice = sender as! IndexPath
            
            let array = sousMenuArray[indice.row] as! Dictionary<String,String>
            DVC.myLib = array["libelleFood"]!
            DVC.descriptionFood = array["descriptionFood"]!
            DVC.prix = array["prixFood"]!
            DVC.remiseFood = array["prixRemise"]!
            DVC.imgFood = array["imageFood"]!
        }
    }
  
    
    func getSousMenu(){
        // Call LibelleCatFood.php
        let url3 : String = IP.init().url+"ListeFood.php?libelleFood="+myCat
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call LibelleCatFood.php is sucess!")
                let results = response.result.value as! NSArray
                self.sousMenuArray = results
                self.tableView.reloadData()
            }
            else {
                print("Call LibelleCatFood.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
}

