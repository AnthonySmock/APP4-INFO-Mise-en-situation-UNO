//
//  ConstructCard.swift
//  UNO
//
//  Created by user on 15/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation
import UIKit

public class ConstructCard {
    
    class func imageCard(chiffre : Int , couleurcarte : String , size : CGSize) -> UIImage{
        
        var imagefond = UIImage()
        var couleur = UIColor.whiteColor()
        
        switch couleurcarte {
        case "bleu":
            imagefond = UIImage(named: "carte bleu.png")!
            couleur = UIColor.blueColor()
        case "jaune":
            imagefond = UIImage(named: "carte jaune.png")!
            couleur = UIColor.yellowColor()
        case "rouge":
            imagefond = UIImage(named: "carte rouge.png")!
            couleur = UIColor.redColor()
        case "vert":
            imagefond = UIImage(named: "carte verte.png")!
            couleur = UIColor.greenColor()
        default: break
        }
        
        imagefond = imageWithImage(imagefond, scaledToSize: size)
        
        let imagetext = ConstructCard.addChiffre("\(chiffre)", inImage: imagefond, atPoint: CGPoint(x: (size.width/2)-7, y: size.height/2 - 15), couleur: couleur)
        
        return imagetext
        
    }
    
    class func addChiffre(drawText: NSString, inImage: UIImage, atPoint:CGPoint , couleur : UIColor)->UIImage{
        
        let textColor: UIColor = couleur
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 25)!
        
        UIGraphicsBeginImageContext(inImage.size)
    
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]

        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage

    }
    
    class func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

public extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }  
}


