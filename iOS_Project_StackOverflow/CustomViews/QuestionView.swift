//
//  QuestionView.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var profileImage: CustomUIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var answerCount: UILabel!
    
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var answerHolder: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit(){
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        profileImage.round()
    }
    
    func populateView(withData question: Question){
        
        self.title.text = question.title.html2String
        self.profileName.text = question.owner.display_name.html2String
        self.profileImage.downloadImage(from: question.owner.profile_image ?? "")
        self.answerCount.text = String(question.answer_count)
        self.answerText.text = question.answer_count == 1 ? "answer" : "answers"
    }

}
