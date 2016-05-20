//
//  PlateauVC.swift
//  UNO
//
//  Created by user on 14/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation
import UIKit

let reuseIdentifier = "CellCard"

class PlateauVC: UIViewController, UICollectionViewDelegate {
    
    var detailItem :Dictionary<String,AnyObject>? {
        didSet {
            // Update the view.
            print(detailItem)
            let cartes = detailItem!["yourCards"] as! Array<Dictionary<String,AnyObject>>
            self.listeCartes = cartes
            nomTable = detailItem!["nom"] as! String
            
            idtable = detailItem!["gid"] as? Int ?? Int(detailItem!["gid"] as! String)!
            Tableid.text = "Table \(nomTable)"
        }
    }//En attente des autres joueurs :
    
    @IBOutlet var cartes : UICollectionView!
    @IBOutlet var carteCentre : UIImageView!
    @IBOutlet var Tableid : UILabel!
    @IBOutlet var time : UILabel!
    @IBOutlet var tour : UILabel!
    @IBOutlet var boutonPiochier:UIButton!
    @IBOutlet var txtpiochier:UILabel!
    @IBOutlet var imgsablier:UIImageView!
    @IBOutlet var attenteimg : UIImageView!
    @IBOutlet var attentetxt : UILabel!
    
    @IBOutlet var nom1:UILabel!
    @IBOutlet var nom2:UILabel!
    @IBOutlet var nom3:UILabel!
    
    @IBOutlet var nb1:UILabel!
    @IBOutlet var nb2:UILabel!
    @IBOutlet var nb3:UILabel!
    
    var nomTable = ""
    var yourposition = 1
    
    
    
    var listeCartes : Array<Dictionary<String,AnyObject>> = []
    var listejoueur : Dictionary<String,Dictionary<String,AnyObject>> = [:]
    var idtable = -1
    var timer = 30
    var clock = NSTimer()
    var timerT = NSTimer()
    var booltour:Bool = false
    var boolbegin:Bool = false
    var boolfinish:Bool = false
    var boolwinner:Bool = false
    var boolprec : Bool?
    var upperCard:Dictionary<String,AnyObject> = ["":""]
    
    var presentWindow : UIWindow?
    let ThemeColor   = UIColor(red: 100/255.0, green: 255/255.0, blue: 100/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.hr_setToastThemeColor(color: ThemeColor)
        presentWindow = UIApplication.sharedApplication().keyWindow
        
        timerT = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PlateauVC.recupplateau), userInfo: nil, repeats: true)
        //recupplateau()
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlateauVC.countdown), userInfo: nil, repeats: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(PlateauVC.testfintimer), userInfo: nil, repeats: true)
        
        cartes.delegate = self
        //majplateau()
        //recupplateau()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listeCartes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let carte = listeCartes[indexPath.row]
        let chiffre = carte["number"] as! Int
        let coul = carte["color"] as! String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CardCell
        
        cell.imgcard.image = ConstructCard.imageCard(chiffre,couleurcarte: coul,size: CGSize(width: 50, height: 66))
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let carte = listeCartes[indexPath.row]
        let chiffre = carte["number"] as! Int
        let coul = carte["color"] as! String
        let cid = carte["cid"] as? Int ?? Int(carte["cid"] as! String)!
        
        carteCentre.image = ConstructCard.imageCard(chiffre,couleurcarte: coul,size: CGSize(width: 50, height: 66))
        listeCartes.removeAtIndex(indexPath.row)
        cartes.reloadData()
        
        let url:NSURL = NSURL(string: VariableGlobale.action)!
        let session = NSURLSession.sharedSession()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int ?? 0
        let gid:Int = prefs.integerForKey("gid") as Int ?? 0
        
        let dico = ["action" : "play" , "pid":pid , "gid":gid , "cid":cid]
        
        let jsondico = (try! NSJSONSerialization.dataWithJSONObject(dico, options: []))
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = jsondico
        
        let semaphore = dispatch_semaphore_create(0)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            print(data)
            /*
            let jsonData_msg : Dictionary<String,NSObject> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,NSObject>
            
            print(jsonData_msg)
            
            self.listeCartes.append(jsonData_msg)
            
            
            print(self.listeCartes)*/
            dispatch_semaphore_signal(semaphore);
            
        }
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        cartes.reloadData()
        booltour = false
        majplateau()
        
        return true
        
    }
    
    @IBAction func piocher(sender : UIButton){
        
        let url:NSURL = NSURL(string: VariableGlobale.action)!
        let session = NSURLSession.sharedSession()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int ?? 0
        let gid:Int = prefs.integerForKey("gid") as Int ?? 0
        
        let dico = ["action" : "draw" , "pid":pid , "gid":gid]
        
        let jsondico = (try! NSJSONSerialization.dataWithJSONObject(dico, options: []))
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = jsondico
        
        let semaphore = dispatch_semaphore_create(0)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            print(data)
            
            let jsonData_msg : Dictionary<String,NSObject> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,NSObject>
            
            print(jsonData_msg)

            self.listeCartes.append(jsonData_msg)
            dispatch_semaphore_signal(semaphore);
            
            print(self.listeCartes)
            
            
        }
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

        cartes.reloadData()
        booltour = false
        majplateau()
    }
    
    func majplateau(){
        if(boolbegin == false){
            attenteimg.hidden = false
            attentetxt.hidden = false
            imgsablier.image = UIImage(named: "stop.jpg")
            timer = 30
            time.text = "\(timer)"
            clock.invalidate()
            tour.text = "Partie non commencée"
            cartes.allowsSelection = false
            cartes.opaque = true
            boutonPiochier.enabled = false
            time.hidden = true
            txtpiochier.hidden = true
            
        }else{
            attenteimg.hidden = true
            attentetxt.hidden = true
            if (booltour == false && (boolprec == true || boolprec == nil)){
                boolprec = false
                imgsablier.image = UIImage(named: "stop.jpg")
                timer = 30
                time.text = "\(timer)"
                clock.invalidate()
                tour.text = "Tours adverses"
                cartes.allowsSelection = false
                cartes.opaque = true
                boutonPiochier.enabled = false
                time.hidden = true
                txtpiochier.hidden = true
                
            }else{
                if(booltour == true && (boolprec == false || boolprec == nil)){
                    boolprec = true
                    let image = UIImage(named: "main3.png")
                    presentWindow!.makeToast(message: "A toi de jouer", duration: 2, position: "center", title: "Image!", image: image!)
                    imgsablier.image = UIImage(named: "sablier4.jpg")
                    clock.invalidate()
                    clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlateauVC.countdown), userInfo: nil, repeats: true)
                    timer = 30
                    time.text = "\(timer)"
                    tour.text = "Votre tour"
                    cartes.allowsSelection = true
                    cartes.opaque = false
                    boutonPiochier.enabled = true
                    txtpiochier.hidden = false
                    //imgsablier.hidden = false
                    time.hidden = false
                    
                }
            }
        }
        if(boolfinish == true){
            if(boolwinner == true){
                attenteimg.image = UIImage(named: "Winning.png")
                attenteimg.hidden = false
                attentetxt.hidden = true
            }else{
                attenteimg.image = UIImage(named: "game over.jpg")
                attenteimg.hidden = false
                attentetxt.hidden = true
            }
        }else{
            attenteimg.hidden = true
            attentetxt.hidden = true
        }
        print(listejoueur)
        switch yourposition {
        case 1:
            if(listejoueur["2"] != nil){
                nom1.text = listejoueur["2"]!["username"] as! String
                nb1.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["3"] != nil){
                nom2.text = listejoueur["3"]!["username"] as! String
                nb2.text = "\(listejoueur["3"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["4"] != nil){
                nom3.text = listejoueur["4"]!["username"] as! String
                nb3.text = "\(listejoueur["4"]!["numberOfCards"] as! String) cartes restante"
            }
        case 2 :
            if(listejoueur["3"] != nil){
                nom1.text = listejoueur["3"]!["username"] as! String
                nb1.text = "\(listejoueur["3"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["4"] != nil){
                nom2.text = listejoueur["4"]!["username"] as! String
                nb2.text = "\(listejoueur["4"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["1"] != nil){
                nom3.text = listejoueur["1"]!["username"] as! String
                nb3.text = "\(listejoueur["1"]!["numberOfCards"] as! String) cartes restante"
            }
        case 3:
            if(listejoueur["4"] != nil){
                nom1.text = listejoueur["4"]!["username"] as! String
                nb1.text = "\(listejoueur["4"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["1"] != nil){
                nom2.text = listejoueur["1"]!["username"] as! String
                nb2.text = "\(listejoueur["1"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["2"] != nil){
                nom3.text = listejoueur["2"]!["username"] as! String
                nb3.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
            }
        case 4:
            if(listejoueur["1"] != nil){
                nom1.text = listejoueur["1"]!["username"] as! String
                nb1.text = "\(listejoueur["1"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["2"] != nil){
                nom2.text = listejoueur["2"]!["username"] as! String
                nb2.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
            }
            if(listejoueur["3"] != nil){
                nom3.text = listejoueur["3"]!["username"] as! String
                nb3.text = "\(listejoueur["3"]!["numberOfCards"] as! String) cartes restante"
            }
        default:
            break
        }
        
        /*
        switch listejoueur.count {
        case 0...1:
            break
        case 2:
            nom1.text = listejoueur["2"]!["username"] as! String
            nb1.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
        case 3:
            nom1.text = listejoueur["2"]!["username"] as! String
            nb1.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
            nom2.text = listejoueur["3"]!["username"] as! String
            nb2.text = "\(listejoueur["3"]!["numberOfCards"] as! String) cartes restante"
        case 4:
            nom1.text = listejoueur["2"]!["username"] as! String
            nb1.text = "\(listejoueur["2"]!["numberOfCards"] as! String) cartes restante"
            nom2.text = listejoueur["3"]!["username"] as! String
            nb2.text = "\(listejoueur["3"]!["numberOfCards"] as! String) cartes restante"
            nom3.text = listejoueur["4"]!["username"] as! String
            nb3.text = "\(listejoueur["4"]!["numberOfCards"] as! String) cartes restante"
        default:
            break
        }*/
        print(listeCartes)
        cartes.reloadData()
        if(upperCard["color"] != nil){
            let coul = upperCard["color"] as! String
            let chiffre = upperCard["number"] as! Int
            carteCentre.image = ConstructCard.imageCard(chiffre,couleurcarte: coul,size: CGSize(width: 50, height: 66))
        }
        
    }
    
    func recupplateau(){
        
        let url:NSURL = NSURL(string: VariableGlobale.recupplateau)!
        let session = NSURLSession.sharedSession()
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let pid:Int = prefs.integerForKey("pid") as Int ?? 0
        let gid:Int = prefs.integerForKey("gid") as Int ?? 0
        
        let dico = ["pid" : pid ,"gid" : gid ]

        let jsondico = (try! NSJSONSerialization.dataWithJSONObject(dico, options: []))
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = jsondico
        
        let semaphore = dispatch_semaphore_create(0)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            print(data)
            
            let jsonData_msg : Dictionary<String,AnyObject> = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! Dictionary<String,AnyObject>
            
            print(jsonData_msg)
            self.listeCartes.removeAll()
            
            self.boolbegin = jsonData_msg["isBegun"] as! Bool
            self.boolfinish = jsonData_msg["isFinished"] as! Bool
            self.boolwinner = jsonData_msg["isWinner"] as! Bool
            
            self.booltour = jsonData_msg["isYourTurn"] as! Bool
            
            self.listejoueur = jsonData_msg["othersNumberOfCards"] as? Dictionary<String,Dictionary<String,AnyObject>> ?? [:]
            self.upperCard = jsonData_msg["upperCard"] as? Dictionary<String,AnyObject> ?? [:]
            self.listeCartes = jsonData_msg["yourCards"] as! Array<Dictionary<String,AnyObject>>
            self.yourposition = jsonData_msg["yourPosition"] as? Int ?? Int(jsonData_msg["yourPosition"] as! String)!

            dispatch_semaphore_signal(semaphore);
            
            print(self.listeCartes)
            
            
        }
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        print(listeCartes)
        majplateau()
    }
    
    func countdown() {
        timer -= 1
        time.text = "\(timer)"
    }
    
    func testfintimer(){
        if (timer < 1 && booltour == true){
            boutonPiochier.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
    }
    
    @IBAction func clique(sender: UIButton){
        clock.invalidate()
        timerT.invalidate()
    }

 
 
}

