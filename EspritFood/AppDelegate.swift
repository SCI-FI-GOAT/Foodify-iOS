//
//  AppDelegate.swift
//  EspritFood
//
//  Created by user on 10/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var userArray: NSArray = []
    var window: UIWindow?
    

    static var usermail : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential)
            {
                (result, error) in
                if error == nil {
                    
                    print("Mail is ",String((result?.user.email)!))
                    // "Value is Optional(42)"
                    
                    let mail:String = String((result?.user.email)!)
                    let name:String = String((result?.user.displayName)!)
                    print(mail)
                    print(name)
                    
                    AppDelegate.usermail = mail
                    
                    
                    
                    
                    //self.userDefault.set(true,forKey: "usersignedin")
                    //self.userDefault.synchronize()
                    
                    
                    //Verification d'existance
                    let url3 : String = IP.init().url+"RoleClient.php?username="+mail
                    Alamofire.request(url3, method: .get).responseJSON {
                        (response) in
                        if response.result.isSuccess {
                            print("Call RoleClient.php is sucess!")
                            let results = response.result.value as! NSArray
                            //print(results)
                            
                            let resDict = results[0] as! Dictionary<String,String>
                            
                            if (resDict["Role"] == "0" ){
                                //client
                                self.window?.rootViewController?.performSegue(withIdentifier: "toHomeClient", sender: nil)
                            }
                            else if (resDict["Role"] == "1" ){
                                //admin
                                self.window?.rootViewController?.performSegue(withIdentifier: "toHomeAdmin", sender: nil)
                            }
                            else {
                                //inscription
                                let urlInsert = IP.init().url+"InscriptionClient.php"
                                let params : Parameters = [
                                    "nom":name,
                                    "email":mail,
                                    "username":mail,
                                    "prenom":"***",
                                    "tel":"***",
                                    "password":"***"
                                ]
                                
                                Alamofire.request(urlInsert, method: .post, parameters: params).responseString(completionHandler: {
                                    (response) in
                                    switch response.result {
                                    case .success:
                                        print("Bienvenue 1")
                                        self.window?.rootViewController?.performSegue(withIdentifier: "toHomeClient", sender: nil)
                                        break
                                    case .failure(let error):
                                        
                                        print("Bienvenue 2")
                                        self.window?.rootViewController?.performSegue(withIdentifier: "toHomeClient", sender: nil)
                                        
                                        
                                    }
                                })
                            }
                            
                            
                            
                            
                        }
                        else {
                            print("Call ListeOffreClient.php failed! Erreur :", response.result.error!)
                        }
                    }
                    
                    /*
                    // Insert User
                    
                     
*/
                    
                    
                }else{ print((error?.localizedDescription))
                    
                }
            }
        }
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])-> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    /*// FB Etape 2 :
    func applications(_ application: UIApplication, open url :URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(application, open: url, options: options)
        return handled!
    }*/
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EspritFood")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}

