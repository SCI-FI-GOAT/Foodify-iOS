//
//  MenuAddViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class MenuAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,  UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var AddImg: UIImageView!
    @IBOutlet weak var txt_libelle: UITextField!
    @IBOutlet weak var txt_description: UITextField!
    @IBOutlet weak var txt_prix: UITextField!
    
    let imagePicker = UIImagePickerController() 
    
    var imageStr : String = ""
    
    var menuArray:NSArray=[]
    
    var menuArray2 = ["66","55","66","77","88"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //dawer trah
        // Call LibelleCatFood.php
        let url3 : String = IP.init().url+"LibelleCatFood.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call LibelleCatFood.php is sucess!")
                let results = response.result.value as! NSArray
                self.menuArray = results
                self.pickerView.reloadAllComponents()
            }
            else {
                print("Call LibelleCatFood.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    //Picker Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let lib : String
        
        let commandeDict = menuArray[row] as! Dictionary<String,String>
        lib = commandeDict["libelleCategorie"]!
        
        return lib
    }
  
    @IBAction func AjouterMenu(_ sender: Any) {
        
        
        if((txt_description.text!.isEmpty)||(txt_prix.text!.isEmpty)||(txt_libelle.text!.isEmpty)||(imageStr == "")) {
            let alert = UIAlertController(title:"Erreur",message:"Remplissez tout les champs s'il vous plaît",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        
        
        
        
        print(pickerView.selectedRow(inComponent: 0)+1)
       
        
        //Ajouter Food
        let urlInsert = IP.init().url+"AjouterFood2.php"
        let params : Parameters = [
            "libelle_food":txt_libelle.text!,
            "prix_food":txt_prix.text!,
            "description":txt_description.text!,
            "id_categorie":pickerView.selectedRow(inComponent: 0)+1,
            "image":imageStr
        ]
        
    
        Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                print("Success 1")
                print(response.description)
                break
            case .failure(let error):
                
                print("Success 2")
                
            }
        })
        
    }

    
    @IBAction func uploadPressed(_ sender: Any) { //
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    //Fonction 1
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            AddImg.contentMode = .scaleAspectFit
            
            AddImg.image = selectedImage
            
            let img = AddImg.image?.jpegData(compressionQuality: 0.5)
            //let imgTry = UIImage(named: "email")!
            
            //let imgtry2 = imgTry.jpegData(compressionQuality: 0.1)
            
            imageStr = img!.base64EncodedString()
            
            
            
            //AddImg.image = getImageFromBase64(base64: imageStr)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "icon-menu2"), tag: 3)
    }
    
}

