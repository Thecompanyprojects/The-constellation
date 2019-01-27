//
//  InAppPurchaseCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//订购Card
/*
 
 - (void)insertVipPayCardForIndex:(NSInteger)index{
 [[XYManager sharedInstance] checkVipStatusComplete:^(BOOL isVip) {
 if (!isVip){
 XYBaseModel *adModel = [[XYBaseModel alloc] init];
 adModel.cardType = @(400001);
 NSMutableArray *arrM_ = [NSMutableArray arrayWithArray:self.model.cardList];
 if (arrM_.count >index){
 [arrM_ insertObject:adModel atIndex:index];
 self.model.cardList = arrM_.copy;
 [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
 }
 }
 }];
 }
 
 
import Foundation
import UIKit
class XYInAppPurchaseCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        
        addSubview(backImageView)
        addSubview(textA)
        addSubview(iconImage)
        
        textA.font = preferredFont(size: 14)
    
        backImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(topMargin)
            make.bottom.equalTo(self).offset(-topMargin)
            make.left.equalTo(self).offset(leftMargin)
            make.right.equalTo(self).offset(-leftMargin)
        }
        
        textA.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-15)
        }
        
        iconImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.right.equalTo(textA.snp.left).offset(-5)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- lazy
    private lazy var textA = UILabel(title: "GET PREMIUM \n Tody`s Psychic Tip")
    

    private lazy var backImageView :UIImageView = {
       let v = UIImageView(image: #imageLiteral(resourceName: "homeCard_插图"))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        
        return v
    }()
    private lazy var iconImage = UIImageView(image: #imageLiteral(resourceName: "大图标 付费页钻石"))

}
*/
