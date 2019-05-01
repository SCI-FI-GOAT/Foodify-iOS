//
//  MenuViewController.swift
//  EspritFood
//
//  Created by user on 14/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var menuArray : NSArray = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getMenu()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath)
        
        let content = cell.viewWithTag(0)
        
        let imageview = content?.viewWithTag(1) as! UIImageView
        let label = content?.viewWithTag(2) as! UILabel
        let imagesDict = menuArray[indexPath.row] as! Dictionary<String,String>
        
        label.text=imagesDict["libelleCategorie"]
        let urls:String = IP.init().url+"images/"+imagesDict["imageCategorie"]!
        imageview.af_setImage(withURL: URL(string: urls)!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goSousMenu", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSousMenu" {
            
            let DVC = segue.destination as! SousMenuViewController
            let indice = sender as! IndexPath
            let array = menuArray[indice.row] as! Dictionary<String,String>
            DVC.myCat = array["libelleCategorie"]!
        }
    }
    
    func getMenu(){
        // Call LibelleCatFood.php
        let url3 : String = IP.init().url+"LibelleCatFood.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call LibelleCatFood.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.menuArray = results
                self.tableView.reloadData()
            }
            else {
                print("Call LibelleCatFood.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "icon-menu2"), tag: 2)
    }
    
}
