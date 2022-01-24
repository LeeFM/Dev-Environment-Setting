//
//  String+TimeAgo.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/9/22.
//  Copyright © 2021 mitake. All rights reserved.
//

extension String {
    func getTimeAgoString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let usLocale = Locale(identifier: "zh_TW")
        dateFormatter.locale = usLocale
        
        if let fromDate = dateFormatter.date(from: self),
           let nowDate = dateFormatter.date(from: Utility.getTime14()) {
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.day, .hour, .minute], from: fromDate, to: nowDate)
            
            let fromDateComponents = calendar.dateComponents([.year, .month, .day], from: fromDate)
            
            //大於一天顯示 年/月/日
            if let day = components.day, day >= 1,
               let fromDateYear = fromDateComponents.year,
               let fromDateMonth = fromDateComponents.month,
               let fromDateDay = fromDateComponents.day {
                
                return String(format: "%04ld/%02ld/%02ld", fromDateYear, fromDateMonth, fromDateDay)
            }
            //大於一小時顯示 ?小時前
            else if let hour = components.hour,
                    let minute = components.minute,
                    (hour * 60 + minute) >= 60 {
                return String(format: "%tu小時前", hour)
            }
            //小於一小時顯示 ?分鐘前
            else if let minute = components.minute, minute > 0 {
                return String(format: "%tu分鐘前", minute)
            }
            else {
                return "剛剛"
            }
        } else {
            return self
        }
    }
}
