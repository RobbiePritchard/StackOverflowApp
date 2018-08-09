//
//  Network.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//



import Foundation


protocol Downloadable {}

struct User: Codable{
    var profile_image: String?
    var display_name: String
}
struct QuestionHolder: Codable, Downloadable{
    var items: [Question]
    var has_more: Bool

}
struct AnswerHolder: Codable, Downloadable{
    var items: [Answer]
}

struct Question: Codable{
    var owner: User
    var answer_count: Int
    var creation_date: Int
    var question_id: Int
    var body_markdown: String
    var title: String
}

struct Answer: Codable{
    var owner: User
    var creation_date: Int
    var score: Int
    var body_markdown: String
}


enum DownloadStatus{
    case Complete(Downloadable)
    case Error(String)
}

class Networker {
    static let shared = Networker()
    
    
    
    func downloadQuestions(at page: Int,completion: @escaping (DownloadStatus) -> ()){
        if let url = URL(string: "https://api.stackexchange.com/2.2/search?page=\(page)&order=desc&sort=activity&intitle=swift&site=stackoverflow&filter=!t)I7RsGWPb1mh(QtE)r3yjgN(PpaML6"){
            
            
            do{
                // get response
                let jsonLine = try String(contentsOf: url, encoding: .utf8)
                
                // parse response
                let questions = try parseQuestionsHolder(json: jsonLine)
                return completion(.Complete(questions))
                
            } catch let error{
                completion(.Error(error.localizedDescription))
            }

        }
    }
    
    func parseQuestionsHolder(json: String) throws -> QuestionHolder {
        let decoder = JSONDecoder()
        return try decoder.decode(QuestionHolder.self, from: json.data(using: .utf8)!)
    }
    
    func downloadAnswers(to questionID: Int, completion: @escaping (DownloadStatus) -> ()){
        if let url = URL(string: "https://api.stackexchange.com/2.2/questions/\(questionID)/answers?order=desc&sort=activity&site=stackoverflow&filter=!4*tK)Ila.PYfe*rH6"){
            do{
                //get response
                let jsonLine = try String(contentsOf: url, encoding: .utf8)
                let answers = try parseAnswerHolder(json: jsonLine)
                // parse response
                return completion(.Complete(answers))
                
            } catch let error{
                completion(.Error(error.localizedDescription))
            }
            
        }
    }
    
    func parseAnswerHolder(json: String) throws -> AnswerHolder {
        let decoder = JSONDecoder()

        return try decoder.decode(AnswerHolder.self, from: json.data(using: .utf8)!)
    }
}
