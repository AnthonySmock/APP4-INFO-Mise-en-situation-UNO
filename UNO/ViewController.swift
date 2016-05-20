//
//  ViewController.swift
//  UNO
//
//  Created by Wiame on 17/05/2016.
//  Copyright © 2016 Wiame. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet var labelogin : UILabel?
    
    @IBOutlet var labelpsw : UILabel?
    
    @IBOutlet var Textlog : UITextField?
    
    @IBOutlet var TextPwd : UITextField?
    
    
    // La première fonction appelée
    override func viewDidLoad() {
        super.viewDidLoad()
        Textlog?.delegate = self
        TextPwd?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -(keyboardSize.height - 50)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = 0
        }
    }
    //
    @IBAction func connexion(connexion : UIButton){
        
        
            SwiftSpinner.show("Chargement")
            // Envoie les données de connexion vers l'API
            
            let url:NSURL = NSURL(string: "http://dev.asmock.com/api/connection")!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            let dico = ["username" : Textlog!.text!, "password": TextPwd!.text!] as Dictionary<String,AnyObject>
            
            let jsonData = (try! NSJSONSerialization.dataWithJSONObject(dico, options: NSJSONWritingOptions()))
            
            request.HTTPBody = jsonData
            
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
                    SwiftSpinner.hide()
                    dispatch_async(dispatch_get_main_queue()){
                        SCLAlertView().showError("Erreur", subTitle: "L'identifiant saisi ou le mots de passe est incorrecte ")
                        self.dismissViewControllerAnimated(false, completion: nil)
                    };
                    //let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    //prefs.setInteger(5, forKey: "pid")
                    //prefs.synchronize()

                    
                    
                }else{
                    let jsonData_msg = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Array<Dictionary<String,AnyObject>>
                    SwiftSpinner.hide()
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setInteger(Int(jsonData_msg[0]["pid"] as! String)!, forKey: "pid")
                    prefs.synchronize()
                    print(jsonData_msg)
                    
                }
                
                
                
            }
            
            task.resume()
        }
    




}

