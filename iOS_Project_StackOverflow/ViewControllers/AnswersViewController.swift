//
//  AnswersViewController.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit


class AnswersViewController: UIViewController {

    
    @IBOutlet weak var answersTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noAnswersLabel: UILabel!

    var answers = [Answer]()
    
    // from QuestionViewController
    var question: Question!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup tableView
        answersTableView.delegate = self
        answersTableView.dataSource = self
        

        //allow back button inside of cell
        NotificationCenter.default.addObserver(self, selector: #selector(AnswersViewController.backButtonPress(_:)), name: NSNotification.Name(rawValue: "BackButton"), object: nil)
        
        // start activity indicator
        activityIndicator.startAnimating()
        
        // load answers if there are more than 0
        question.answer_count == 0 ? self.noAnswersLabel.isHidden = false : loadAnswers()

    }
    @objc func backButtonPress(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    func loadAnswers(){
        Networker.shared.downloadAnswers(to: question.question_id){ response in
            
            // hide activity indicator
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            
            switch response{
            case .Complete(let answers):
                // no errors
                self.answers = (answers as! AnswerHolder).items

                DispatchQueue.main.async {
                    self.answersTableView.reloadData()
                }
            // errors
            case .Error(let errorMessage):
                print(errorMessage)
                self.noAnswersLabel.text = """
                ☠️
                Error downloading answers.
                
                Check your internet connection.
                """
                self.noAnswersLabel.isHidden = false

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}


extension AnswersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count + 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get top (question cell)
        if indexPath.item == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionBodyCell") as! QuestionBodyCell
            cell.questionBodyLabel.text = question.body_markdown
            cell.holderView.addBottomShadow(color: UIColor.orange.cgColor)
            cell.questionView.populateView(withData: question)

            return cell
        }
        // get answer cell
        let answer = answers[indexPath.item - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! AnswerCell
        cell.populateView(withData: answer)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y < 0){
            scrollView.contentOffset.y = 0
        }
    }

}

class QuestionBodyCell: UITableViewCell{
    
    @IBOutlet weak var holderView: UIView!
    
    @IBOutlet weak var questionView: QuestionView!

    @IBOutlet weak var questionBodyLabel: UILabel!
    
    @IBAction func backButtonPress(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BackButton"), object: self)
    }
}
