//
//  ViewController.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit



class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var connectionErrorViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    // holds the questions and status of next page
    var questionHolder:QuestionHolder!
    
    
    var questions = [Int:QuestionHolder]()
    
    
    // page logic controls
    let FirstPage = 1
    var currentPage = 1
    var lastDownloadedPage = 1
    var finalPage = Int.max
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.isHidden = true

        downloadQuestions(){ _ in }
    }
    
    func retryDownload(){

        downloadQuestions(at: lastDownloadedPage){ done in
            if done{
                self.connectionErrorViewBottom.constant = -150
            } else{
                print("no")
            }
        }
    }

    @IBAction func retryButtonPress(_ sender: UIButton) {
        retryDownload()
    }
    
    
    func downloadQuestions(at page: Int = 1, completion: @escaping (Bool) -> ()){
        print("downloading at page: \(page)")
        DispatchQueue.global(qos: .background).async {
            Networker.shared.downloadQuestions(at: page){ response in
                switch response{
                // no error
                case .Complete(let questionHolder ):
                    
                    // load question to tableView
                    self.loadQuestions(from: questionHolder as! QuestionHolder)
                    
                    // set last page if found
                    if !self.questionHolder.has_more{
                        self.finalPage = self.lastDownloadedPage
                    }
                    
                    self.lastDownloadedPage += 1
                    completion(true)
                // error
                case .Error( _):
                    //show error message
                    DispatchQueue.main.async {
                        self.connectionErrorViewBottom.constant = 0
                    }
                    completion(false)
                }
            }
        }

    }
    
    func loadQuestions(from newQuestionHolder: QuestionHolder){
        self.questionHolder = newQuestionHolder
        self.questions[self.lastDownloadedPage] = newQuestionHolder
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func downloadNextPage(){
        guard let holder = questionHolder else{
            return
        }
        if holder.has_more{
            print("getting new data")
            downloadQuestions(at: currentPage + 1){
                done in

                if done { self.currentPage += 1 }
                else { return }
            }
        }
    }
    
    // MARK: UI Updates

    func toggleButtons(){
        // hide next button if were on the last page
        nextButton.isHidden = currentPage == finalPage
        
        // hide back button if were on the first page
        backButton.isHidden = currentPage == FirstPage
    }
    
    func updatePageLabel(){
        pageLabel.text = String(currentPage)
    }
    
    
    // MARK: Page Actions
    
    @IBAction func backButtonPress(_ sender: Any) {
        currentPage -= 1
        tableView.reloadData()
        
        toggleButtons()
        updatePageLabel()
    }
    
    @IBAction func nextButtonPress(_ sender: Any) {

        // if we have already downloaded a page, load it
        if let _ = questions[currentPage + 1]{
            print("got old data")
            currentPage += 1
            tableView.reloadData()
        } else{
            downloadNextPage()
        }
        toggleButtons()
        updatePageLabel()
    }
    

}


// MARK: UITableView

extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = questions[currentPage]?.items else{
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionCell
        let question = questions[currentPage]!.items[indexPath.item]
        cell.loadView(withData: question)
        cell.updateConstraintsIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "answers") as! AnswersViewController

        vc.question = questions[currentPage]!.items[indexPath.item]
        
        self.show(vc, sender: nil)
    }

    
}



