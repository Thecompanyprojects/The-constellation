//
//  XYCircleMenu.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/10/30.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

import UIKit

@objc(XYCircleMenuDelegate)
protocol XYCircleMenuDelegate:NSObjectProtocol {
    func circleMenuClickBtn(index:Int)
}


@objcMembers
class XYCircleMenu:UIView{
    
    deinit {
        printLog("我已释放")
    }
    //    #define DIST(pointA,pointB) sqrtf((pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y))
    
    weak var delegate : XYCircleMenuDelegate?
    
    let menuRadius  = 0.5 * UIScreen.main.bounds.size.width
    let proportion = 0.5          //中心圆直径与菜单变长的比例
    
    
    private var imageArr = [String]()
    
   @objc convenience init(frame: CGRect,imageArr:[String]) {
        self.init(frame: frame)
        self.imageArr = imageArr
        
//        self.rotationCircleCenter(contentOrgin:
//            CGPoint.init(x: menuRadius, y: menuRadius),
//                                  contentRadius: Double(menuRadius),
//                                  imageNameArray: imageArr,
//                                  imageTitleArray: ["1","2","3","4"])
    
    }
    
    func beginAnimate(){
       let viewArr = creat4View()
        let time = 0.03
        
        
        let options : UIView.AnimationOptions = [.curveEaseOut]
        
        UIView.animate(withDuration: time, delay: 0, options: options, animations: {
            viewArr[1].frame = self.calculationFrameForInder(index: 1)
            viewArr[2].frame = self.calculationFrameForInder(index: 1)
            viewArr[3].frame = self.calculationFrameForInder(index: 1)
        }) { (_) in
            UIView.animate(withDuration: time, delay: 0, options: options, animations: {
                viewArr[2].frame = self.calculationFrameForInder(index: 2)
                
            }, completion: { (_) in
                viewArr[3].frame = self.calculationFrameForInder(index: 2)
                UIView.animate(withDuration: time, delay: 0, options: options, animations: {
                    viewArr[3].frame = self.calculationFrameForInder(index: 3)
                    
                }, completion: { (_) in
                    
                })
            })
            
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func creat4View()->[UIView]{
        
        let count : Double = Double(imageArr.count)
        
        let x = Double(menuRadius)*sin(.pi/count*Double(0)-(.pi/2*0.75))
        let y = Double(menuRadius)*cos(.pi/count*Double(0)-(.pi/2*0.75))
        
        var viewArr = [UIView]()
        
        for i in 0..<imageArr.count{
            let view = CircleMenuBtn(frame: calculationFrame(contentRadius:Double(menuRadius),x:x,y:y), tag: i) {[weak self] (tag)  in
                print("点解了TBtn\(tag)")
                self?.delegate?.circleMenuClickBtn(index: tag)
            }
            
            view.image = UIImage.init(named: imageArr[i])
            view.title = imageArr[i]
//            viewArr.insert(view, at: 0)
            viewArr.append(view)
            self.insertSubview(view, at: 0)
//            self.addSubview(view)
        }
        return viewArr
    }
    
    
    
    func rotationCircleCenter(contentOrgin:CGPoint,
                              contentRadius:Double,
                              imageNameArray:[String],
                              imageTitleArray:[String]){
        
        let count : Double = Double(imageNameArray.count)
        
        
        for i in 0..<imageNameArray.count{
            
            let x = contentRadius*sin(.pi/count*Double(i)-(.pi/2*0.75))
            let y = contentRadius*cos(.pi/count*Double(i)-(.pi/2*0.75))
            
            let view = CircleMenuBtn(frame: calculationFrame(contentRadius:contentRadius,x:x,y:y), tag: i) { (tag) in
                print("点解了TBtn\(tag)")
            }

            view.image = UIImage.init(named: imageNameArray[i])
            view.title = imageTitleArray[i]
            
            self.addSubview(view)
        }}
    
    
    func calculationFrameForInder(index:Int)->CGRect{
        let count : Double = Double(imageArr.count)
        
        let contentRadius : Double = Double(menuRadius)
        
        let x = contentRadius*sin(.pi/count*Double(index)-(.pi/2*0.75))
        let y = contentRadius*cos(.pi/count*Double(index)-(.pi/2*0.75))
        
        return calculationFrame(contentRadius:contentRadius,x:x,y:y)
    }
    
    func calculationFrame(contentRadius:Double,x:Double,y:Double)->CGRect{
    
        let x = contentRadius + 0.5 * (1 + proportion) * x - 0.5 * (1 - proportion) * contentRadius
        let y = contentRadius - 0.5 * (1 + proportion) * y - 0.5 * (1 - proportion) * contentRadius
        
        return CGRect.init(x:x,y:y+100,width:(1 - proportion) * contentRadius,height:(1 - proportion) * contentRadius)
        
    }
}

class CircleMenuBtn: UIView {
    var title : String?{
        didSet{
            //self.titleL.text = title
        }
    }
    var image : UIImage?{
        didSet{
            self.imageView .setImage(image, for: UIControl.State.normal)
        }
    }
    
    
    private lazy var imageView = UIButton()
    private lazy var titleL = UILabel()
    
    typealias ClickBtn = (_ tag:Int)->()
    
    var clickBtnFinish:ClickBtn?
    
    @objc func clickBtn(sender:UIButton){
        
        self.clickBtnFinish?(self.tag)
    }
    
    
    convenience init(frame: CGRect,tag:Int,clickFinish:@escaping ClickBtn) {
        self.init(frame: frame)
        
        self.tag = tag
        self.clickBtnFinish = clickFinish
        
        self.isUserInteractionEnabled = true
        imageView = UIButton(frame: CGRect.init(x: 10, y: 0,
                                                width: (self.frame.width-20),
                                                height: (self.frame.width-20)))
        
        
        
        //        imageView.tag = 100 + i
        imageView.addTarget(self, action: #selector(clickBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        titleL = UILabel(frame: CGRect.init(x: 0, y: self.frame.width-20, width: self.frame.width, height: 20))
        
        titleL.textAlignment = .center
        titleL.font = UIFont.systemFont(ofSize: 13)
        
        self.addSubview(imageView)
        self.addSubview(titleL)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


