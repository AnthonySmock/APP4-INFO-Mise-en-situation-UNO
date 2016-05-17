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
    
    var listArray = [
        ["idTables": 1, "nb": 1, "isSubList": 0, "subList": ["pwd":"coucou","isSubList": 1]],
        ["idTables": 2, "nb": 3, "isSubList": 0, "subList": ["pwd":"","isSubList": 1]],
        ["idTables": 3, "nb": 4, "isSubList": 0, "subList": ["pwd":"coucou","isSubList": 1]],
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        self.tableView.reloadData()
        
        recupdonnees()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TablesVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= (keyboardSize.height - 30)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += (keyboardSize.height - 30)
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
            cellMain.idTable.text = "Table n°\(dict["idTables"]!)"
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
    
    func configureMainCell(cell : UITableViewCell, withObject dict:Dictionary<String,AnyObject>){
        
        let imageName:String? = (dict["iconName"] as? String)
        let list:String? = (dict["listName"] as? String)
        
        let listNamelabel:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        listNamelabel.text = list
        
        
        let disclosureImage:UIImageView = cell.contentView.viewWithTag(5555) as! UIImageView
        
        if let x: AnyObject = dict["subList"] {
            disclosureImage.hidden = false
        }else{
            disclosureImage.hidden = true
        }
        
        
    }
    func configureSubCell(cell : UITableViewCell, withObject dict:Dictionary<String,AnyObject>){
        
        let imageName:String? = (dict["iconName"] as? String)
        let list:String? = (dict["listName"] as? String)
        
        let listNamelabel:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        //label.text = la
        listNamelabel.text = list
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
        
        let item = self.listArray[sender.tag - 1]
        let itemmdp = self.listArray[sender.tag]
        
        var indxesPath:NSIndexPath = NSIndexPath(forRow:(sender.tag),inSection:0)
        let cell = tableView.cellForRowAtIndexPath(indxesPath)
        
        let mdptxt:UITextField = cell!.contentView.viewWithTag(100) as! UITextField
        
        if(mdptxt.text == itemmdp["pwd"] as! String){
            
            print(sender.tag)
            let idtable = item["idTables"] as! Int
            
            (seguesauv.destinationViewController as! PlateauVC).detailItem = ["cartes" : [["couleur" : "bleu" ,"chiffre" : 8, "id":1],["couleur" : "jaune" ,"chiffre" : 1, "id":1],["couleur" : "rouge" ,"chiffre" : 6, "id":1],["couleur" : "vert" ,"chiffre" : 2, "id":1],["couleur" : "bleu" ,"chiffre" : 8, "id":1],["couleur" : "jaune" ,"chiffre" : 1, "id":1],["couleur" : "rouge" ,"chiffre" : 6, "id":1],["couleur" : "vert" ,"chiffre" : 2, "id":1],["couleur" : "bleu" ,"chiffre" : 8, "id":1],["couleur" : "jaune" ,"chiffre" : 1, "id":1],["couleur" : "rouge" ,"chiffre" : 6, "id":1],["couleur" : "vert" ,"chiffre" : 2, "id":1]], "idTable" : idtable]
        }else{
            SCLAlertView().showError("Erreur", subTitle: "Mot de passe non valide")
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    
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
        
        let url:NSURL = NSURL(string: "http://dev.asmock.com/api/carte")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        /*
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        */
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let jsonData_msg:Dictionary<String, AnyObject> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String, AnyObject>
            
            print(jsonData_msg)
            
        }
        
        task.resume()
    
    }
    

    
}
