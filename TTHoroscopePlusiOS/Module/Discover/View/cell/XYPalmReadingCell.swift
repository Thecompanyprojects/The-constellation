//
//  XYPalmReadingCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/28.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

import UIKit

@objcMembers
class XYPalmReadingModel: NSObject {
    var name = ""
    var imageName = ""
    var isSelected = false
    var id = 0
    
    
    class func getModels()->[[XYPalmReadingModel]]{
        
        let arrString =
        [["Long & Clear",
        "lifeline_Short & Strong",
        "Short but Shallow",
        "Long & Wavery",
        "Doubled or Tripled"],
        ["Swooping",
        "Cramped",
        "Crossing the Palm"],
        ["Lines Moving Up",
        "Lines Moving Down",
        "lifeline_Break",
        "Island",
        "lifeline_Chained"],
        ["Deep & Straight",
        "Short & Strong",
        "Light & Wavery",
        "Short Upcurved",
        "Long Upcurved",
        "headline_Doubled"],
        ["headline_Chained",
        "headline_Break",
        "Forked",
        "Joined to Life Line",
        "Seperated from Life Line"],
        ["Starts Under the Index Finger",
        "Starts Between Middle & Index Finger",
        "Starts Under the Middle Finger",
        "Long",
        "Short"],
        ["heartline_Doubled",
        "Upward Lines",
        "Downward Lines",
        "heartline_Break",
        "heartline_Chained"],
        ["The Square Hand",
        "The Pointed Hand",
        "The Conical Hand",
        "The Spade-Shaped Hand",
        "The Mixed Hand"]]
        
        
        var arrModels = [[XYPalmReadingModel]]()
        
        var id = 0
        for strArr in arrString{
            var arrModelsB = [XYPalmReadingModel]()
            for i in 0..<strArr.count{
                let model = XYPalmReadingModel()
                model.imageName = strArr[i]
                model.name = strArr[i]
                model.isSelected = false
                id += 1
                model.id = id
                arrModelsB.append(model)
            }
            arrModels.append(arrModelsB)
        }
        return arrModels
    }
    
}

@objcMembers
class XYPalmReadingCell: UICollectionViewCell {
    
    var model : XYPalmReadingModel?{
        didSet{
            guard let nModel = model else {
                return
            }
            
            if nModel.name.contains("heartline_") {
               nModel.name = nModel.name.replacingOccurrences(of: "heartline_", with: "")
            }else
            if nModel.name.contains("lifeline_") {
                nModel.name = nModel.name.replacingOccurrences(of: "lifeline_", with: "")
            }else
            if nModel.name.contains("headline_"){
                nModel.name = nModel.name.replacingOccurrences(of: "headline_", with: "")
            }
            
            name.text = nModel.name
            image.image = UIImage(named: nModel.imageName)
            selectedImage.isHidden = !nModel.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        selectedImage.isHidden = true
        
        addSubview(image)
        addSubview(selectedImage)
        addSubview(name)
        
        
        image.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.69)
            make.height.equalTo(image.snp.width).multipliedBy(1.25)
        }
        
        selectedImage.snp.makeConstraints { (make) in
            make.edges.equalTo(image)
        }
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(image.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var selectedImage = UIImageView(image: #imageLiteral(resourceName: "xuanzhong_selected"))
     lazy var image = UIImageView()
     lazy var name = UILabel(fontName: UIFontName.century_Gothic.rawValue,
                             textSize: 12,
                             color: UIColor.black)
}
