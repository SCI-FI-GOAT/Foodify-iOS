//
//  ListeOffresViewController.swift
//  EspritFood
//
//  Created by user on 07/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ListeOffresViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var offresTable: UITableView!
    var offresArray : NSArray = []

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOffresData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offre", for: indexPath)
        
        let content = cell.viewWithTag(0)
        
        let IMGOffre = content?.viewWithTag(1) as! UIImageView
        let LBLid = content?.viewWithTag(2) as! UILabel
        let LBLdate = content?.viewWithTag(3) as! UILabel
        let LBLlibelle = content?.viewWithTag(4) as! UILabel
        let LBLtaux = content?.viewWithTag(5) as! UILabel
        let LBLdesc = content?.viewWithTag(6) as! UILabel
        
        
        
        let cmdDict = offresArray[indexPath.row] as! Dictionary<String,String>
        
        let urls:String = IP.init().url+"images/"+cmdDict["image"]!
        IMGOffre.af_setImage(withURL: URL(string: urls)!)
            
        LBLid.text = "N° " + cmdDict["id_offre"]!
        LBLdate.text = cmdDict["date"]
        LBLlibelle.text = cmdDict["libelle_food"]
        LBLtaux.text = "- " + cmdDict["taux"]! + " %"
        LBLdesc.text = cmdDict["description"]

  
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            
            //Suuprimer Offre
            let resultDict = offresArray[indexPath.row] as! Dictionary<String,String>
         
            
            let urlInsert = IP.init().url+"SupprimerOffre.php"
            let params : Parameters = [
                "id_offre":resultDict["id_offre"]!,
                "taux":"- " + resultDict["taux"]! + " %",
                "libelle_food":resultDict["libelle_food"]!
            ]
            
            Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
                (response) in
                switch response.result {
                case .success:
                    print("Success 1")
                    break
                case .failure(let error):
                    
                    print("Success 2",error)
                    self.viewWillAppear(true)
                    
                }
            })
            
            
            let alert = UIAlertController(title:"Succés",message:"Offre supprimée",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            
        }
    }
    
    

    
    
    func getOffresData(){
        let url4 : String = IP.init().url+"ListeOffreAdmin.php"
        Alamofire.request(url4, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListeOffreAdmin.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.offresArray = results
                
                self.offresTable.reloadData()
                
                
            }
            else {
                print("Call ListeOffreAdmin.php failed! Erreur :", response.result.error!)
                
            }
        }
    }
    
    
    @IBAction func btn_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
