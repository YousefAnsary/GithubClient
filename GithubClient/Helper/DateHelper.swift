//
//  DateHelper.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    let dateFormatter: DateFormatter
    
    private init() {
        self.dateFormatter = DateFormatter()
    }
    
    func string(fromDate date: Date, withFormat format: String)-> String {
        dateFormatter.dateFormat = format//"dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    func changeDateFormat(date: String, sentDateFormat: String, desiredFormat: String)-> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = sentDateFormat
        let date = inputDateFormatter.date(from: date)
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = desiredFormat
        return outputDateFormatter.string(from: date ?? Date())
    }
    
}
