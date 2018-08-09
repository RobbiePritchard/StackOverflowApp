//
//  AnswerCell.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation
import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var holder: UIView!
    
    @IBOutlet weak var profileImage: CustomUIImageView!
    
    @IBOutlet weak var body: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    
    override func prepareForInterfaceBuilder() {
    }
    
    
    func populateView(withData answer: Answer){
        profileImage.round()
        holder.addBottomShadow()
        profileImage.downloadImage(from: answer.owner.profile_image!)
        profileName.text = answer.owner.display_name.html2String
        body.text = answer.body_markdown
    }
}
