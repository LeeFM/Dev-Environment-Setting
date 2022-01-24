//
//  UILabel+ReadMoreTrailing.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/11/26.
//  Copyright © 2021 mitake. All rights reserved.
//

import Foundation

extension UILabel {
    
    func getPartialContentWithTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor, boundaryNumberOfLines: Int) -> String? {
        guard let text = self.text,
              let vissibleTextLength = self.getVissibleTextLength(boundaryNumberOfLines: boundaryNumberOfLines),
              vissibleTextLength > 0
        else {
            return nil
        }
        
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = vissibleTextLength
        let mutableString: String = text
        let trimmedString: String = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: (text.count - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        
        var trimmedForReadMore: String = ""
        // 擷取完的字串以\n結尾表示內容有連續的\n\n，此時直接拼接trailing，否則會replace到上一行的內容
        if trimmedString.last == "\n" {
            trimmedForReadMore = trimmedString + trailingText
        } else {
            trimmedForReadMore = (trimmedString as NSString).replacingCharacters(in: NSRange(location: (trimmedString.count - readMoreLength), length: readMoreLength), with: "") + trailingText
        }
        
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        return answerAttributed.string
    }
    
    private func getVissibleTextLength(boundaryNumberOfLines: Int) -> Int? {
        let font: UIFont = self.font
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = boundaryNumberOfLines == 0 ? self.frame.size.height : (font.lineHeight * CGFloat(boundaryNumberOfLines))
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes)
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            
            while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size.height <= labelHeight
            {
                prev = index
                index += 1
            }
            return prev
        } else {
            return nil
        }
    }
}
