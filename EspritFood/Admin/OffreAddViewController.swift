//
//  OffreAddViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire


class OffreAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let catArray = ["Pizza","Plat","Sandwich","Boisson","Portion"]
    var foodArray :NSArray = []
    
    
    @IBOutlet weak var pickerCategorie: UIPickerView!
    @IBOutlet weak var pickerFood: UIPickerView!
    @IBOutlet weak var textFieldReduction: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    var selectedPickerValue = ""
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        afficheMenu(selectedCat: "Pizza")
    }
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldDescription.text = ""
        textFieldReduction.text = ""
        
    }
    
    @IBAction func ajouterOffre(_ sender: Any) {
        
        if((textFieldDescription.text!.isEmpty)||(textFieldReduction.text!.isEmpty)) {
            
            let alert = UIAlertController(title:"Erreur",message:"Remplissez tout les champs s'il vous plaît",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        
        
        
        
        addOffre()
        
        let alert = UIAlertController(title:"Succés",message:"Offre ajoutée",preferredStyle: .alert)
        let ok = UIAlertAction(title:"OK", style: .cancel)
        alert.addAction(ok)
        
        self.present(alert, animated:true ,completion: nil)

    }
    
    //Picker Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return catArray.count
        } else {
            return foodArray.count
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            
            return catArray[row]
        } else {
            let lib : String
            
            index = row
            let commandeDict = foodArray[row] as! Dictionary<String,String>
            lib = commandeDict["libelleFood"]!
            
            return lib
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            afficheMenu(selectedCat: catArray[row])
        } else {
            let commandeDict = foodArray[row] as! Dictionary<String,String>
            selectedPickerValue = commandeDict["libelleFood"]!
            

            
            
        }
    }
    
    func afficheMenu(selectedCat:String){
        
        // Call LibelleCatFood.php
        let url3 : String = IP.init().url+"ListeFood.php?libelleFood="+selectedCat
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeFood.php is sucess!")
                let results = response.result.value as! NSArray
                self.foodArray = results
                
                let commandeDict = self.foodArray[self.index] as! Dictionary<String,String>
                self.selectedPickerValue = commandeDict["libelleFood"]!
                
                self.pickerFood.reloadAllComponents()
            }
            else {
                print("Call ListeFood.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    func addOffre(){
        //Ajouter Food
        let urlInsert = IP.init().url+"AjouterOffre.php"
        
        let dict = foodArray[pickerFood.selectedRow(inComponent: 0)] as! Dictionary<String,String>
        
        let params : Parameters = [
            "libelle_food":dict["libelleFood"]!,
            "taux":textFieldReduction.text!,
            "description":textFieldDescription.text!
        ]
        
        Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                print("Success 1")
                break
            case .failure(let error):
                
                print("Success 2")
                if(response.result.description.contains("Erreur")){
                    let alert = UIAlertController(title:"Erreur",message:"Offre non ajoutée, Veuillez verifier si elle exisite déja !",preferredStyle: .alert)
                    let ok = UIAlertAction(title:"OK", style: .cancel)
                    alert.addAction(ok)
                    
                    self.present(alert, animated:true ,completion: nil)
                    return
                }
                
            }
        })
        
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Offre", image: UIImage(named: "icon-offre"), tag: 2)
    }
    
}
