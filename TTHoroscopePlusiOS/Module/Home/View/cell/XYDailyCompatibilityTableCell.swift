//
//  XYDailyCompatibilityTableCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/17.
//  Copyright © 2018年 xykj.inc All rights reserved.
//每日匹配星座Card
//cardType = 7;
//content =             {
//    Emotional = 76;
//    Intellectual = 100;
//    Physical = 98;
//    Social = 92;
//    Spiritual = 68;
//};
//percent = 86;
//sign1 = 6;
//sign2 = 10;
//title = "Daily Compatibility";
import UIKit
import SnapKit

@objcMembers
class XYDailyCompatibilityTableCell: UITableViewCell {
    var model : TTDailyCompatibilityModel?{
        didSet{
            guard let nModel = model else {
                
                return
            }
            
            printLog(nModel)
            
            compatibility.text = "\(nModel.percent)" + "%"
            
            let zodiacSignModel = TTLocalDataManager().zodiacSignModels[nModel.sign1-1]
            constellationA.image = UIImage(named: zodiacSignModel.titleImageName)?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay)
            
            let zodiacSignModel2 = TTLocalDataManager().zodiacSignModels[nModel.sign2-1]
            constellationB.image = UIImage(named: zodiacSignModel2.titleImageName)?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay)
            
            constellation.text = zodiacSignModel.zodiacName + " & " + zodiacSignModel2.zodiacName
            
            if let p = Int(nModel.content["Intellectual"]!){
                contentAP.progress = Float(p) / 100
                contentAPL.text = " \(p)%"
            }
            
            if let p = Int(nModel.content["Physical"]!){
                contentBP.progress = Float(p) / 100
                contentBPL.text = " \(p)%"
            }
            if let p = Int(nModel.content["Social"]!){
                contentCP.progress = Float(p) / 100
                contentCPL.text = " \(p)%"
            }
            if let p = Int(nModel.content["Spiritual"]!){
                contentDP.progress = Float(p) / 100
                contentDPL.text = " \(p)%"
            }
            if let p = Int(nModel.content["Emotional"]!){
                contentEP.progress = Float(p) / 100
                contentEPL.text = " \(p)%"
            }
            
            //    Emotional = 76;
            //    Intellectual = 100;
            //    Physical = 98;
            //    Social = 92;
            //    Spiritual = 68;
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        selectionStyle = .none
   
        addSubview(backView)
        
        addSubview(title)
        addSubview(constellation)
        addSubview(constellationIconBorderA)
        addSubview(constellationIconBorderB)
        addSubview(constellationA)
        addSubview(constellationB)
        addSubview(minLine)
        
        addSubview(compatibility)
        
        addSubview(contentA)
        addSubview(contentAP)
        addSubview(contentAPL)
        
        addSubview(contentB)
        addSubview(contentBP)
        addSubview(contentBPL)
        
        addSubview(contentC)
        addSubview(contentCP)
        addSubview(contentCPL)
        
        addSubview(contentD)
        addSubview(contentDP)
        addSubview(contentDPL)
        
        addSubview(contentE)
        addSubview(contentEP)
        addSubview(contentEPL)
        
        let topV = UIView()
        topV.backgroundColor = UIColor.groupTableViewBackground
        addSubview(topV)
        topV.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(self)
        }
        
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(topMargin+10*heightScale)
            make.left.equalTo(backView).offset(15)
        }
        
        constellation.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(30)
            make.centerX.equalTo(title)
        }
        
        constellationIconBorderA.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerX.equalTo(title).offset(-30)
            make.top.equalTo(constellation.snp.bottom).offset(10)
        }
        
        minLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(constellationIconBorderA)
            make.left.equalTo(constellationIconBorderA.snp.right).offset(3)
        }
        
        constellationA.snp.makeConstraints { (make) in
            make.center.equalTo(constellationIconBorderA)
            make.width.height.equalTo(27)
        }
        
        constellationIconBorderB.snp.makeConstraints { (make) in
            make.width.height.equalTo(constellationIconBorderA)
            make.left.equalTo(minLine.snp.right).offset(3)
            make.centerY.equalTo(constellationIconBorderA)
        }
        
        constellationB.snp.makeConstraints { (make) in
            make.center.equalTo(constellationIconBorderB)
            make.width.height.equalTo(30)
        }
        

        compatibility.snp.makeConstraints { (make) in
            make.top.equalTo(constellationIconBorderB.snp.bottom).offset(5)
            make.centerX.equalTo(title)
            make.bottom.equalTo(self).offset(-topMargin*2 - 10)
        }
        
        contentE.snp.makeConstraints { (make) in
            make.bottom.equalTo(backView).offset(-15)
            make.right.equalTo(contentAP.snp.left).offset(-10)
        }
        
        contentD.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentE.snp.top).offset(-15)
            make.left.equalTo(contentE)
        }
        
        contentC.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentD.snp.top).offset(-15)
            make.left.equalTo(contentD)
        }
        contentB.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentC.snp.top).offset(-15)
            make.left.equalTo(contentC)
        }
        contentA.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentB.snp.top).offset(-15)
            make.left.equalTo(contentB)
        }
        
        contentAP.snp.makeConstraints { (make) in
            make.right.equalTo(backView).offset(-45*widthScale)
            make.centerY.equalTo(contentA)
            make.width.equalTo(90*widthScale)
            make.height.equalTo(3)
        }
        
        contentBP.snp.makeConstraints { (make) in
            make.right.equalTo(contentAP)
            make.centerY.equalTo(contentB)
            make.width.height.equalTo(contentAP)
        }
        contentCP.snp.makeConstraints { (make) in
            make.right.equalTo(contentAP)
            make.centerY.equalTo(contentC)
            make.width.height.equalTo(contentAP)
        }
        contentDP.snp.makeConstraints { (make) in
            make.right.equalTo(contentAP)
            make.centerY.equalTo(contentD)
            make.width.height.equalTo(contentAP)
        }
        contentEP.snp.makeConstraints { (make) in
            make.right.equalTo(contentAP)
            make.centerY.equalTo(contentE)
            make.width.height.equalTo(contentAP)
        }
        
        
        contentAPL.snp.makeConstraints { (make) in
            make.left.equalTo(contentAP.snp.right)
            make.centerY.equalTo(contentAP)
        }
        
        contentBPL.snp.makeConstraints { (make) in
            make.left.equalTo(contentBP.snp.right)
            make.centerY.equalTo(contentBP)
        }
        contentCPL.snp.makeConstraints { (make) in
            make.left.equalTo(contentCP.snp.right)
            make.centerY.equalTo(contentCP)
        }
        contentDPL.snp.makeConstraints { (make) in
            make.left.equalTo(contentDP.snp.right)
            make.centerY.equalTo(contentDP)
        }
        
        contentEPL.snp.makeConstraints { (make) in
            make.left.equalTo(contentEP.snp.right)
            make.centerY.equalTo(contentEP)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private lazy var title : UILabel = {
        let b = UILabel(title: "Daily Compatibility")
        b.font = preferredFont(size: 15*widthScale)
        b.textColor = UIColor(hex: 0x333333)
       return b
    }()
    
    private lazy var constellationIconBorderA : UIView={
       let a = UIView()
        a.layer.borderWidth = 2
        a.layer.cornerRadius = 25
        a.layer.borderColor = UIColor.black.cgColor
        a.layer.masksToBounds = true
        return a
    }()
    
    private lazy var constellationA = UIImageView()
    private lazy var constellationIconBorderB : UIView={
        let a = UIView()
        a.layer.borderWidth = 2
        a.layer.cornerRadius = 25
        a.layer.borderColor = UIColor.black.cgColor
        a.layer.masksToBounds = true
        return a
    }()
    
    private lazy var constellationB = UIImageView()
    private lazy var minLine = UILabel(title: "—", fontName: UIFontName.pingfang_sc_medium.rawValue, textSize: 12, color: UIColor.black, alpha: 1)
    
    
//星座名字&星座名字
    private lazy var constellation : UILabel = {
        let b = UILabel(title: "--")
        b.textColor = UIColor(hexString: "#333333")
        
        b.font = UIFont.init(name: UIFontName.pingfang_sc_regular.rawValue, size: 13)//preferredFont(size: 13)//
        return b
    }()
    
    //%匹配度
    private lazy var compatibility : UILabel = {
        let b = UILabel(color: UIColor(hexString: "#333333"))
        b.font = customFont(size: 16, name: UIFontName.pingfang_sc_light)
        return b
    }()
    
    private lazy var contentA : UILabel = {
        let a = UILabel(title: "Intellectual")
        a.textColor = UIColor(hexString: "#333333")
        a.font = UIFontName.pingfang_sc_regular.font(size: 12*widthScale)
        return a
    }()
    private lazy var contentB : UILabel = {
        let a  = UILabel(title: "Physical")
        a.textColor = UIColor(hexString: "#333333")
        a.font = UIFontName.pingfang_sc_regular.font(size: 12*widthScale)
        return a
    }()
    private lazy var contentC : UILabel = {
        let a  = UILabel(title: "Social")
        a.textColor = UIColor(hexString: "#333333")
        a.font = UIFontName.pingfang_sc_regular.font(size: 12*widthScale)
        return a
    }()
    private lazy var contentD : UILabel = {
        let a  = UILabel(title: "Spiritual")
        a.textColor = UIColor(hexString: "#333333")
        a.font = UIFontName.pingfang_sc_regular.font(size: 12*widthScale)
        return a
    }()
    private lazy var contentE : UILabel = {
        let a  = UILabel(title: "Emotional")
        a.textColor = UIColor(hexString: "#333333")
        a.font = UIFontName.pingfang_sc_regular.font(size: 12*widthScale)
        return a
    }()
    
    private lazy var contentAP : UIProgressView = {
       let a = UIProgressView()
        a.progressTintColor = UIColor(hexString: "#ee6a4c")
        a.trackTintColor = UIColor(white: 0.8, alpha: 1)
        a.layer.cornerRadius = 1.5
        a.layer.masksToBounds = true
        return a
    }()
    private lazy var contentBP : UIProgressView = {
        let a = UIProgressView()
        a.progressTintColor = UIColor(hexString: "#eaaa41")
        a.trackTintColor = UIColor(white: 0.8, alpha: 1)
        a.layer.cornerRadius = 1.5
        a.layer.masksToBounds = true
        return a
    }()
    private lazy var contentCP : UIProgressView = {
        let a = UIProgressView()
        a.progressTintColor = UIColor(hexString: "#add685")
        a.trackTintColor = UIColor(white: 0.8, alpha: 1)
        a.layer.cornerRadius = 1.5
        a.layer.masksToBounds = true
        return a
    }()
    private lazy var contentDP : UIProgressView = {
        let a = UIProgressView()
        a.progressTintColor = UIColor(hexString: "#6ac6ff")
        a.trackTintColor = UIColor(white: 0.8, alpha: 1)
        a.layer.cornerRadius = 1.5
        a.layer.masksToBounds = true
        return a
    }()
    
    private lazy var contentEP : UIProgressView = {
        let a = UIProgressView()
        a.progressTintColor = UIColor(hexString: "#c56aff")
        a.trackTintColor = UIColor(white: 0.8, alpha: 1)
        a.layer.cornerRadius = 1.5
        a.layer.masksToBounds = true
        return a
    }()
    private lazy var contentAPL : UILabel = {
        let a = UILabel(title: "-", fontName: UIFontName.pingfang_sc_regular.rawValue, textSize: 10, color: UIColor.black)
        return a
    }()
    private lazy var contentBPL : UILabel = {
        let a = UILabel(title: "-", fontName: UIFontName.pingfang_sc_regular.rawValue, textSize: 10, color: UIColor.black)
        return a
    }()
    private lazy var contentCPL : UILabel = {
        let a = UILabel(title: "-", fontName: UIFontName.pingfang_sc_regular.rawValue, textSize: 10, color: UIColor.black)
        return a
    }()
    
    private lazy var contentDPL : UILabel = {
        let a = UILabel(title: "-", fontName: UIFontName.pingfang_sc_regular.rawValue, textSize: 10, color: UIColor.black)
        return a
    }()
    
    private lazy var contentEPL : UILabel = {
        let a = UILabel(title: "-", fontName: UIFontName.pingfang_sc_regular.rawValue, textSize: 10, color: UIColor.black)
        return a
    }()
    
    private lazy var backView :UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white//.withAlphaComponent(0.1)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        return v
    }()
}






class LCCircleProgress: UIView {


    override func layoutSubviews() {
        super.layoutSubviews()
        printLog("------------------------------\(self.frame)")
        
        self.radius = frame.width/2
        setUI()
    }
    
    
    
    /** 进度 */
    var progress : CGFloat = 0 {
        didSet{
            self.topLayer.strokeEnd = progress
        }
    }

    private var progressWidth : CGFloat = 1{
        didSet{
            topLayer.lineWidth = progressWidth
            bottomLayer.lineWidth = progressWidth
        }
    }

init(frame:CGRect,radius:CGFloat,progressWidth:CGFloat,topColor:UIColor,bottomColor:UIColor) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.radius = radius
        self.topLayer.strokeColor = topColor.cgColor
        centerBall.fillColor = UIColor.clear.cgColor

        self.bottomLayer.strokeColor = bottomColor.cgColor

        self.progressWidth = progressWidth
        topLayer.lineWidth = progressWidth
        bottomLayer.lineWidth = progressWidth
        setUI()
    
    /* 这里开始初始化 */
    
    //如果需要重新调用drawRect则设置contentMode为UIViewContentModeRedraw
    self.contentMode = UIView.ContentMode.redraw
    //不允许从Autoresizing转换Autolayout的Constraints
    //貌似Storyboard创建时调用initWithCoder方法时translatesAutoresizingMaskIntoConstraints已经是NO了
    self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //#pragma mark - 初始化页面
    func setUI() {
        self.layer.addSublayer(bottomLayer)
        self.layer.addSublayer(topLayer)
        self.layer.addSublayer(centerBall)
//        self.addSubview(progressLabel)
        self.addSubview(timeLabel)


        origin = CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)

        radius = self.bounds.size.width / 2
        timeLabel.sizeToFit()
        timeLabel.center = CGPoint.init(x: origin.x, y: origin.y)
//        progressLabel.center = CGPoint.init(x: origin.x, y: origin.y+20)

        let bottomPath = UIBezierPath(arcCenter: origin, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        self.bottomLayer.path = bottomPath.cgPath


        let fillPath = UIBezierPath(arcCenter: origin, radius: radius - 12, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        centerBall.path = fillPath.cgPath


        //        startAngle = CGFloat(-Double.pi/2)
        //        endAngle = startAngle - progress * CGFloat(Double.pi) * 2

        startAngle = CGFloat(-Double.pi/2)
        endAngle =  3 * .pi / 2
        let topPath = UIBezierPath.init(arcCenter: origin, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        topLayer.path = topPath.cgPath
        topLayer.strokeEnd = 0
    }


    /** 原点 */
    private var origin : CGPoint = CGPoint.init()
    /** 半径 */
    private var radius : CGFloat = 15
    /** 起始 */
    private var startAngle : CGFloat = 0
    /** 结束 */
    private var endAngle : CGFloat = 1

    var timeLabel = UILabel()
    /** 进度显示 */
//    var progressLabel : UILabel = UILabel.init(title: "—— min ——",
//                                               fontName:UIFontName.pingfang_sc_light.rawValue,
//                                               textSize:20,
//                                               color: UIColor.white, numberOfLines: 1)
    /** 填充layer */
    private var topLayer : CAShapeLayer = {
        let lay = CAShapeLayer.init()
        lay.lineCap =  CAShapeLayerLineCap.round //CAShapeLayerLineCap.round
        lay.fillColor = UIColor.clear.cgColor
        lay.strokeColor = UIColor.blue.cgColor
        return lay
    }()
    /** 边框layer */
    private var bottomLayer : CAShapeLayer = {
        let lay = CAShapeLayer.init()
        lay.fillColor = UIColor.clear.cgColor
        lay.strokeColor = UIColor.gray.cgColor
        return lay
    }()

    private var centerBall : CAShapeLayer = {
        let lay = CAShapeLayer.init()
        return lay
    }()
}
