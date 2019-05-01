//
//  MapViewController.swift
//  EspritFood
//
//  Created by user on 14/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController {
    
    var restaurantArray : NSArray = []

    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRetauData()
        
    }
    func getRetauData(){
        // Call ListeOffreClient.php
        let url3 : String = IP.init().url+"Restaurants.php"
        Alamofire.request(url3, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call Restaurants.php is sucess!")
                let results = response.result.value as! NSArray
                //print(results)
                self.restaurantArray = results
                
                
                for i in  0 ... self.restaurantArray.count - 1 {
                    let resultDict = self.restaurantArray[i] as! Dictionary<String,String>
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(resultDict["cordonneeX"]!)!,longitude: Double(resultDict["cordonneeY"]!)!)
                    
                    annotation.title = "EspritFood " + resultDict["villeRestau"]!
                    annotation.subtitle = resultDict["adresseRestau"]!
                    
                    self.map.addAnnotation(annotation)
                }
                
                
            }
            else {
                print("Call Restaurants.php failed! Erreur :", response.result.error!)
            }
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "icon-map2"), tag: 4)
    }
}
