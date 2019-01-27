//
//  XYCelestialPlanetCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/17.
//  Copyright © 2018年 xykj.inc All rights reserved.
//星球

import UIKit
let leftMargin = 0
let topMargin = 8 * heightScale

fileprivate let collectionHeight : CGFloat = 35
@objcMembers
class XYCelestialPlanetCell: UITableViewCell,UICollectionViewDataSource {
  
    var dataSource = [[String:Any]]()
    var model : XYPlanetModel?{
        didSet{
            printLog(model!)
            guard let nModel = model else {
                return
            }
            
            if let data = nModel.data as? [[String:Any]]{
                dataSource = data
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = UIColor.groupTableViewBackground
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        
        
        
        addSubview(collection)
        
        collection.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(leftMargin)
            make.right.equalTo(self).offset(-leftMargin)
            make.top.equalTo(self)
            make.height.equalTo((collectionHeight+20)*5+20)
            make.bottom.equalTo(self)
//            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collection : UICollectionView = {
       let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: PlanetCollectionViewFlowLayout())
            v.backgroundColor = UIColor.white
//        v.layer.masksToBounds = true
//        v.layer.cornerRadius = 5
        v.register(PlanetCollectionItem.self, forCellWithReuseIdentifier: "PlanetCollectionItem")
        v.dataSource = self
        return v
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCollectionItem", for: indexPath) as! PlanetCollectionItem
        
        cell.modelDic = dataSource[indexPath.item]
        return cell
    }
}


fileprivate class PlanetCollectionItem: UICollectionViewCell {
 
    var planets = [1:"Moon",
                   2:"Sun",
                   3:"Mercury",
                   4:"Venus",
                   5:"Mars",
                   6:"Jupiter",
                   7:"Saturn",
                   8:"Uranus",
                   9:"Neptune",
                   10:"Pluto"]
    
    var modelDic : [String:Any]=[:]{
        didSet{

            if let a = modelDic["content"] as? String{
                content.text = a
            }
            if let a = modelDic["planet_content"] as? String{
                planet_content.text = a
            }
            if let a = modelDic["planet_id"] as? Int{
                icon.image  = UIImage(named: planets[a] ?? "")
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        icon.image = #imageLiteral(resourceName: "符号 天蝎")
        
        
        addSubview(icon)
        addSubview(planet_content)
        addSubview(content)
       
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        planet_content.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(4)
            make.centerY.equalTo(icon).offset(-10)
        }
        content.snp.makeConstraints { (make) in
            make.left.equalTo(planet_content)
            make.centerY.equalTo(icon).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var icon : UIImageView = UIImageView()
    
    private lazy var planet_content : UILabel = {
        let v = UILabel(title: "--")
        v.textColor = UIColor(hex: 0x333333)
        v.font = customFont(size: 12*widthScale, name: UIFontName.pingfang_sc_light)
        return v
    }()
    
    private lazy var content : UILabel = {
        let v = UILabel(title: "--")
        v.textColor = UIColor(hex: 0x333333)
        v.font = customFont(size: 10, name: UIFontName.pingfang_sc_thin)
        return v
    }()
    
    
}


class PlanetCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        let rowCount : CGFloat = 2
        
        var cellMargin : CGFloat = 15 * widthScale
        if UIScreen.main.bounds.size.width > 375 {
            cellMargin = 15 * 1.3
        }
        
        let lineSpacing : CGFloat = 20.0
        
        let topInset = 20 //- (UIDevice.current.isX() ? 88 : 64)
        self.sectionInset = UIEdgeInsets.init(top: CGFloat(topInset), left: cellMargin, bottom: 0, right: cellMargin);
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = cellMargin //列间距
        self.minimumLineSpacing = lineSpacing//行间距
    
        let totalWidth = UIScreen.main.bounds.width - 30
        let width: CGFloat  = (totalWidth-(rowCount+1)*cellMargin)/rowCount;
        self.itemSize = CGSize.init(width: width, height: collectionHeight)
    }
}

