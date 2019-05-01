//
//  RestaurantAddViewController.swift
//  EspritFood
//
//  Created by user on 01/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class RestaurantAddViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtVille: UITextField!
    @IBOutlet weak var txtAdresse: UITextField!
    
    var lat : Double = 0
    var long : Double = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setMapview()
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        txtVille.text = ""
        txtAdresse.text = ""
        mapView.removeAnnotations(mapView.annotations)

        
    }
    
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(RestaurantAddViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            mapView.removeAnnotations(mapView.annotations)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude,longitude: locationCoordinate.longitude)
            
            lat = locationCoordinate.latitude
            long = locationCoordinate.longitude
            
            
            self.mapView.addAnnotation(annotation)
            
            
            
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    
    @IBAction func btn_ajouter(_ sender: Any) {
        
        print(txtVille.text!)
        print(txtAdresse.text!)
        print(lat)
        print(long)
        print(mapView.annotations.count)
        if((txtAdresse.text!.isEmpty)||(txtVille.text!.isEmpty)) {
            let alert = UIAlertController(title:"Erreur",message:"Remplissez tout les champs s'il vous plaît",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        
        if(mapView.annotations.count < 1 ) {
            let alert = UIAlertController(title:"Erreur",message:"Sélectionnez l'emplacement de votre restaurant (LongClick).",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            return
        }
        
        
        //Ajouter Restau
        let urlInsert = IP.init().url+"AjouterRestauIOS.php"
        let params : Parameters = [
            "villeRestau":txtVille.text!,
            "adresseRestau":txtAdresse.text!,
            "cordonneeX":lat,
            "cordonneeY":long
        ]
        
        Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                print("Success 1")
                
                
                
                break
            case .failure(let error):
                
                print("Success 2")
                let alert = UIAlertController(title:"Succés",message:"Restaurant ajouté",preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
                
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Restau", image: UIImage(named: "icon-map"), tag: 5)
    }
    
}
