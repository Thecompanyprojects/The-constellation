//
//  String+Extension.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

import Foundation
extension String{
    
    /// 计算字符串高度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    /// - Returns:
    func calculateStringHeight(font:UIFont,width:CGFloat)->CGFloat{
        
        if (self.isEmpty || width <= 0){ return 0}
    
        let dic = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):font]
        let measureSize = (self as NSString).boundingRect(with:
                            CGSize.init(width: width, height: CGFloat(MAXFLOAT)),
                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                            attributes: convertToOptionalNSAttributedStringKeyDictionary(dic), context: nil).size

        return ceil(measureSize.height);
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
