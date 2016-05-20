//
//  ViewMeilleurScore.swift
//  UNO
//
//  Created by Wiame on 18/05/2016.
//  Copyright © 2016 Wiame. All rights reserved.
//

import Foundation


import UIKit

class ViewMeilleurScore: UIViewController {
    
    
    @IBOutlet var labelPartie : UILabel?
    
    @IBOutlet var labelGagne : UILabel?
    
    
    
    // La première fonction appelée
    override func viewDidLoad() {
        super.viewDidLoad()
        afficherpartie()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func afficherpartie(){
        
        
        
        // Envoie les données de connexion vers l'API
        
        let url:NSURL = NSURL(string: "http://dev.asmock.com/api/profil")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int
        
        let dico = ["pid" :pid] as Dictionary<String,AnyObject>
        
        let jsonData = (try! NSJSONSerialization.dataWithJSONObject(dico, options: NSJSONWritingOptions()))
        
        request.HTTPBody = jsonData
        let semaphore = dispatch_semaphore_create(0)
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            print(data)
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                SCLAlertView().showError("", subTitle: "Error")
                
            }else{
                let jsonData_msg = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ))

                let partieg = jsonData_msg["gameWon"] as! String
                let partiej = jsonData_msg["gamePlayed"] as! String
                
                
                self.labelGagne!.text = partieg
                self.labelPartie!.text = partiej
                
                print(jsonData_msg)
            }
            
            dispatch_semaphore_signal(semaphore);
            
        }
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}

   