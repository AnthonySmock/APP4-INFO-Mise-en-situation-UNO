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
    
    var detailItem :Dictionary<String,NSObject>? {
        didSet {
            // Update the view.
            let cartes = detailItem!["cartes"] as! Array<Dictionary<String,NSObject>>
            self.listeCartes = cartes
            idtable = detailItem!["idTable"] as! Int
            Tableid.text = "Table n°\(idtable)"
        }
    }
    
    @IBOutlet var cartes : UICollectionView!
    @IBOutlet var carteCentre : UIImageView!
    @IBOutlet var Tableid : UILabel!
    
    var listeCartes : Array<Dictionary<String,NSObject>> = []
    var idtable = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartes.delegate = self
        
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
        let chiffre = carte["chiffre"] as! Int
        let coul = carte["couleur"] as! String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CardCell
        
        cell.imgcard.image = ConstructCard.imageCard(chiffre,couleurcarte: coul,size: CGSize(width: 50, height: 66))
        
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let carte = listeCartes[indexPath.row]
        let chiffre = carte["chiffre"] as! Int
        let coul = carte["couleur"] as! String
        
        print("\(chiffre) " + coul)
        
        carteCentre.image = ConstructCard.imageCard(chiffre,couleurcarte: coul,size: CGSize(width: 50, height: 66))
        listeCartes.removeAtIndex(indexPath.row)
        cartes.reloadData()
        
        return true
        
    }
    
    @IBAction func piocher(sender : UIButton){
        
        listeCartes.append(["couleur" : "bleu" ,"chiffre" : 8])
        
        cartes.reloadData()
        print("Piocher")
    }
 
 
}

