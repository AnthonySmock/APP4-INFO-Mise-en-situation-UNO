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
    
    @IBOutlet var cartes : UICollectionView!
    @IBOutlet var carteCentre : UIImageView!
    
    var listeCartes = [["couleur" : "bleu" ,"chiffre" : 8],["couleur" : "jaune" ,"chiffre" : 1],["couleur" : "rouge" ,"chiffre" : 6],["couleur" : "vert" ,"chiffre" : 2],["couleur" : "bleu" ,"chiffre" : 8],["couleur" : "jaune" ,"chiffre" : 1],["couleur" : "rouge" ,"chiffre" : 6],["couleur" : "vert" ,"chiffre" : 2],["couleur" : "bleu" ,"chiffre" : 8],["couleur" : "jaune" ,"chiffre" : 1],["couleur" : "rouge" ,"chiffre" : 6],["couleur" : "vert" ,"chiffre" : 2]]
    
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

