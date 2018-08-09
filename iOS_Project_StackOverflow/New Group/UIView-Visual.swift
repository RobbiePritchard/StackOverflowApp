//
//  UIView-Visual.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit

extension UIView{
    func round(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func addBottomShadow(size: Double = 1.0, color: CGColor = UIColor.gray.cgColor){
        self.layer.shadowColor = color
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0 , height: size)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
    }
}
