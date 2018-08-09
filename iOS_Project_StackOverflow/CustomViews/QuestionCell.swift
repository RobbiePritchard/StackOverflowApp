//
//  QuestionCell.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class QuestionCell: UITableViewCell{
    
    @IBOutlet weak var questionView: QuestionView!
    
    func loadView(withData question: Question){
        questionView.populateView(withData: question)
    }
}
