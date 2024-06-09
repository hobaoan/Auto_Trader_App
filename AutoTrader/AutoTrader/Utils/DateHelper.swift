//
//  DateHelper.swift
//  AutoTrader
//
//  Created by An Bảo on 28/05/2024.
//

import Foundation

struct DateHelper {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    static func getDateMonthAgo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        if let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
            return dateFormatter.string(from: oneMonthAgo)
        }
        return ""
    }
    
    static func getDateYearAgo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        if let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: currentDate) {
            return dateFormatter.string(from: oneYearAgo)
        }
        return ""
    }
    
    static func convertDateOrther(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    static func convertDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
