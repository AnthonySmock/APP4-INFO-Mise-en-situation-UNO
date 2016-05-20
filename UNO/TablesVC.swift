//
//  TablesVC.swift
//  UNO
//
//  Created by user on 17/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation
import UIKit

class TablesVC: UIViewController ,UITableViewDataSource , UITableViewDelegate, UITextFieldDelegate{
    var selectedIndex :Int = -1
    var subListArray : [[String:AnyObject]] = []
    
    var seguesauv:UIStoryboardSegue = UIStoryboardSegue(identifier: "", source: UIViewController(), destination: UIViewController())
    
    var listArray : Array<Dictionary<String,AnyObject>> = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var nomtable:UITextField!
    @IBOutlet var mdptable:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        self.tableView.reloadData()
        
        recupdonnees()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        nomtable.delegate = self
        mdptable.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -(keyboardSize.height - 30)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dict : [String:AnyObject] = (self.listArray[indexPath.row] as? Dictionary)!
        
        if (self.isSubList(dict)){
            let cellSub = tableView.dequeueReusableCellWithIdentifier("subCell", forIndexPath: indexPath) as! ListeTablesSubCell

            let pwd = dict["pwd"] as! String
            
            if(pwd == ""){
                cellSub.textmdp.hidden = true
                cellSub.button.tag = indexPath.row
                cellSub.txtmdp.text = "Pas de mot de passe"
                return cellSub
            }else{
                cellSub.textmdp.hidden = false
                cellSub.textmdp.delegate = self
                cellSub.button.tag = indexPath.row
                cellSub.txtmdp.text = "Mot de passe"
                return cellSub
            }
        }else{
            let cellMain = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! ListeTablesMainCell
            cellMain.idTable.text = "Table \(dict["nom"]!)"
            cellMain.nbPers.text = "\(dict["nb"]!)/4 Personnes"
            
            return cellMain
        }
        
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        var row = indexPath.row
        
        
        
        let dict : [String:AnyObject] = (self.listArray[row] as? Dictionary<String,AnyObject>)!
        let subListArr : Dictionary<String,AnyObject>?  = (dict["subList"]  as? Dictionary<String,AnyObject>)
        if (selectedIndex == -1){
            if let arr = subListArr  {
                selectedIndex = row
                
                self.subListArray = [arr]
                self.expandList(row, boolSelect: false)
            }
        }else{
            
            if (self.isSubList(dict)){
                //perform Action
            }else{
                self.minimizeList()
                
                if (row == selectedIndex){
                    selectedIndex = -1
                }else{
                    
                    
                    if let arr = subListArr  {
                        self.subListArray = [arr]
                        if (selectedIndex < row && selectedIndex != -1){
                            selectedIndex = row
                            self.expandList(row, boolSelect: true)
                        }else{
                            selectedIndex = row
                            self.expandList(row, boolSelect: false)
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    func isSubList(dict : Dictionary <String, AnyObject>) -> Bool{
        let isSubList : Int = (dict["isSubList"] as? Int)!
        if ( isSubList == 1 ) {
            return true
        }
        return false
    }
    

    
    
    func expandList(atIndex:Int, boolSelect:Bool){
        for (index ,dict) in self.subListArray.enumerate(){
            print(listArray)
            print(selectedIndex)
            if(boolSelect == true){
                self.listArray.insert(dict, atIndex: selectedIndex + index )
            }else{
                self.listArray.insert(dict, atIndex: selectedIndex + index + 1)
            }
            
            
            
            var indxesPath:[NSIndexPath] = [NSIndexPath]()
            if(boolSelect == true){
                indxesPath.append(NSIndexPath(forRow:(selectedIndex + index ),inSection:0))
            }else{
                indxesPath.append(NSIndexPath(forRow:(selectedIndex + index + 1),inSection:0))
            }
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Top)
            self.tableView.endUpdates()
            
        }
        
        
    }
    
    func minimizeList(){
        var i :Int = 0
        while (i < self.listArray.count){
            let index:Int = i
            let dict:Dictionary<String, AnyObject> = self.listArray[index] as! Dictionary<String, AnyObject>
            
            if (self.isSubList(dict as Dictionary<String, AnyObject>)){
                
                let dicts:Dictionary<String, AnyObject> =  self.listArray.removeAtIndex(index) as! Dictionary<String, AnyObject>
                print(dicts)
                
                var indxesPath:[NSIndexPath] = [NSIndexPath]()
                indxesPath.append(NSIndexPath(forRow:(index),inSection:0))
                
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
                
                continue
            }
            i = i+1
        }
        
        
    }

    @IBAction func voirAction(sender: UIButton) {
        
        let item = self.listArray[selectedIndex]
        
        var indxesPath:NSIndexPath = NSIndexPath(forRow:(sender.tag),inSection:0)
        let cell = tableView.cellForRowAtIndexPath(indxesPath)
        
        let gid = item["gid"] as? Int ?? 0
        let mdptxt:UITextField = cell!.contentView.viewWithTag(100) as! UITextField
        
        let url:NSURL = NSURL(string: VariableGlobale.entertable)!
        let session = NSURLSession.sharedSession()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int
        
        prefs.setInteger(gid, forKey: "gid")
        prefs.synchronize()
        var pwd = ""
        if(mdptxt.hidden == false){
            pwd = mdptxt.text!
        }
        
        let dico = ["password" :pwd, "pid" : "\(pid)" , "gid" : "\(gid)"]
        let jsondico = (try! NSJSONSerialization.dataWithJSONObject(dico, options: []))
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = jsondico
        
        let semaphore = dispatch_semaphore_create(0)
        
        _ = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                dispatch_semaphore_signal(semaphore);
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                
                dispatch_async(dispatch_get_main_queue()){
                    SCLAlertView().showError("Erreur", subTitle: "Mot de passe non valide")
                    self.dismissViewControllerAnimated(false, completion: nil)
                };

            }else{
                print(data)
                
                var jsonData_msg:Dictionary<String,AnyObject> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,AnyObject>
                
                print(jsonData_msg)

                jsonData_msg["nom"] = item["nom"] as! String
                jsonData_msg["gid"] = item["gid"] as! Int
                
                (self.seguesauv.destinationViewController as! PlateauVC).detailItem = jsonData_msg as! Dictionary<String, NSObject>
            }
            
            dispatch_semaphore_signal(semaphore);
        }.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "demarerTable" {
            seguesauv = segue
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func recupdonnees(){
        
        let url:NSURL = NSURL(string: VariableGlobale.gettable)!
        let session = NSURLSession.sharedSession()
        listArray.removeAll()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
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
                SCLAlertView().showError("Erreur", subTitle: "Erreur lors de la connexion")
            }else{
                let jsonData_msg: Array<Dictionary<String,AnyObject>> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Array<Dictionary<String,AnyObject>>
                
                print(jsonData_msg)
                
                for table in jsonData_msg{
                    
                    let mdp = table["isPasswordSet"] as! Bool
                    var txtmdp = ""
                    if (mdp == true){
                        txtmdp = "bb"
                    }
                    let nb = Int(table["playerWaiting"] as! String)
                    let name = table["gameName"] as! String
                    let gid = Int(table["gid"] as! String)
                    let arraydicosub: Dictionary<String,AnyObject> = ["pwd":txtmdp,"isSubList" :true] as Dictionary<String,AnyObject>
                    let dicoMain = ["isSubList" :false, "nb" :nb!, "gid" :gid!, "nom":name, "subList":arraydicosub ] as Dictionary<String,AnyObject>

                    
                    self.listArray.insert(dicoMain , atIndex: 0)
                    print(self.listArray)
                    
                }
            }
            dispatch_semaphore_signal(semaphore);
            
        }
        
        task.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.tableView.reloadData()
        self.view.reloadInputViews()
        

    
    }
    
    @IBAction func creeTable(sender: UIButton){
        
        let url:NSURL = NSURL(string: VariableGlobale.creeable)!
        let session = NSURLSession.sharedSession()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int
        
        if(nomtable.text! == ""){
            SCLAlertView().showError("Erreur", subTitle: "Nom de table vide")
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        var dico = ["gameName" :nomtable.text! , "pid":pid, "maxPlayer" : 4] as Dictionary<String,AnyObject>
        
        if(mdptable.text != ""){
            dico["gamePassword"] = mdptable.text!
        }else{
            dico["gamePassword"] = ""
        }
        
        let jsondico = (try! NSJSONSerialization.dataWithJSONObject(dico, options: []))
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = jsondico
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            print(data)
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                
                dispatch_async(dispatch_get_main_queue()){
                    SCLAlertView().showError("Erreur", subTitle: "Erreur")
                    self.dismissViewControllerAnimated(false, completion: nil)
                };
                
                
            }else{
                var jsonData_msg = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,AnyObject>
                
                jsonData_msg["nom"] = self.nomtable.text!
                
                (self.seguesauv.destinationViewController as! PlateauVC).detailItem = jsonData_msg as! Dictionary<String, NSObject>
                
                print(jsonData_msg)
                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setInteger(Int(jsonData_msg["gid"] as! String)!, forKey: "gid")
                prefs.synchronize()
                
            }
            

        }
        
        task.resume()
        
    }
    
    @IBAction func refresh(sender : UIButton){
        recupdonnees()
    }

    

    
}
