//
//  TestVc.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/17.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import Foundation

@objcMembers
class TestVc: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func addCoverToBackImage(){
        
    }
    var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "星座背景"))
        imageView.frame = self.view.bounds
    
        

        
        view.addSubview(imageView)
        
        view.addSubview(tableView)
        
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.clear
        
   
        tableView.register(XYTodyPsychicTipCell.self, forCellReuseIdentifier: "XYTodyPsychicTipCell")
        
        
    }
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseCell")
            
            return cell!
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "XYTodyPsychicTipCell")
            
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseCell")
            
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseCell")
            
            return cell!
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let v = UIView()
//        v.backgroundColor = UIColor.red
//        return v
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v = UIView()
//        v.backgroundColor = UIColor.red
//        return v
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
}
