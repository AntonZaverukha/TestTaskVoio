//
//  StringExtensions.swift
//  TestTaskVoio
//
//  Created by Anton on 30.03.2023.
//

import Foundation

extension String {
    func getYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            return String(calendar.component(.year, from: date))
        }
        return nil
    }
}
