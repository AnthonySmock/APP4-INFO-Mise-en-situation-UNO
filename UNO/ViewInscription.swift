//
//  ViewInscription.swift
//  UNO
//
//  Created by Wiame on 18/05/2016.
//  Copyright © 2016 Wiame. All rights reserved.
//

import Foundation


import UIKit

class ViewInscription: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var labelogin : UILabel?
    
    @IBOutlet var labelpwd : UILabel?
    
    @IBOutlet var labelConfPwd : UILabel?
    
    @IBOutlet var Textlog : UITextField?
    
    @IBOutlet var Textpwd: UITextField?
    
    @IBOutlet var TextConfPwd : UITextField?
    
    @IBOutlet var Inscription : UIButton?
    
    
    // La première fonction appelée
    override func viewDidLoad() {
        super.viewDidLoad()
        Textlog?.delegate = self
        Textpwd?.delegate = self
        TextConfPwd?.delegate = self
        
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
            self.view.frame.origin.y = -(keyboardSize.height - 120)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func Inscription(inscription : UIButton){
        
        
       
        // Test si les deux mots de passe sont conforme 
        
        if(Textpwd!.text != TextConfPwd!.text)
        {
            
            SCLAlertView().showError("Erreur", subTitle: "Les mots de passe saisis ne sont pas identiques")
            
            
        }
        else
        {
        
        // Envoie les données vers l'API
        
        let url:NSURL = NSURL(string: "http://dev.asmock.com/api/subscribe")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
        let dico = ["username" : Textlog!.text!, "password": Textpwd!.text!] as Dictionary<String,AnyObject>
            
        let jsonData = (try! NSJSONSerialization.dataWithJSONObject(dico, options: NSJSONWritingOptions()))
         
        request.HTTPBody = jsonData
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                
                dispatch_async(dispatch_get_main_queue()){
                    SCLAlertView().showError("Erreur", subTitle: "Pseudo ou mot de passe invalide ")
                    self.dismissViewControllerAnimated(false, completion: nil)
                };
                
                
            }else{
                let jsonData_msg = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,AnyObject>
                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setInteger(Int(jsonData_msg["pid"] as! String)!, forKey: "pid")
                prefs.synchronize()
                
            }

            
        }
        
        task.resume()
        }
    }

    
    
}

