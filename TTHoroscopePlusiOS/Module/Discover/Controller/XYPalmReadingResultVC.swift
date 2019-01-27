//
//  XYPalmReadingResultVC.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/29.
//  Copyright © 2018 xykj.inc. All rights reserved.
//结果页

import UIKit
@objcMembers
class XYPalmReadingResultVC: TTBaseViewController {

    
    var selectDic = [NSNumber:XYPalmReadingModel](){
        didSet{
            printLog(selectDic)
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Palm Reading"
        setupUI()
//        self.additionalSafeAreaInsets
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    func setupUI(){
        self.backgroundImage = #imageLiteral(resourceName: "背景图1125 2436")
        
        label.font = preferredFont(size: 13)
        view.addSubview(collectionView)
        view.addSubview(label)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   fileprivate lazy var collectionView : UICollectionView = {
       let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: XYPalmReadingResultLayout())
        c.register(XYPalmReadingCell.self, forCellWithReuseIdentifier: "XYPalmReadingResultVCCell")
        c.register(XYPalmReadingHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "XYPalmReadingResultVCCellHeader")
        c.delegate = self
        c.dataSource = self
    
        c.backgroundColor = .clear
        return c
    }()
    
    fileprivate lazy var backScrollView = UIScrollView()
    
    
    fileprivate lazy var label = UILabel(color: UIColor.white, textAlignment: .left)
}

extension XYPalmReadingResultVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XYPalmReadingResultVCCell", for: indexPath) as! XYPalmReadingCell
        let model = selectDic[NSNumber(value: indexPath.item)]
        model?.isSelected = false
        cell.model = model
        cell.name.font = preferredFont(size: 10)
        model?.isSelected = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "XYPalmReadingResultVCCellHeader", for: indexPath) as! XYPalmReadingHeader
        var resultStr = ""
        for model in selectDic.values{
            if model.id > resultArr.count{
                
            }else{
                resultStr += resultArr[model.id-1] + "\n"
            }
        }
        footer.title.text = resultStr
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var resultStr = ""
        for model in selectDic.values{
            if model.id > resultArr.count{
                
            }else{
                resultStr += resultArr[model.id-1] + "\n"
            }
        }
         let height = resultStr.calculateStringHeight(font: preferredFont(size: 13), width: kWidth-30)
          return CGSize.init(width: kWidth, height: height + 100)
    }
}






class XYPalmReadingResultLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let rowCount : CGFloat = 4
        
        self.sectionInset = UIEdgeInsets.init(top: 20, left: 13, bottom: 30, right: 13);
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = 10 //列间距
        self.minimumLineSpacing = 0//行间距
        
        let totalWidth = UIScreen.main.bounds.width - 26 - (10 * 4)
        let width: CGFloat  = (totalWidth)/rowCount;
        
        
        self.itemSize = CGSize.init(width: width, height: width+20)
    }
}

fileprivate let resultArr = ["You have the best kind of Life Line, long and clearly marked.  This shows that you will possess good health, vitality and a very nice life expectancy.",
                                  "Your Life Line is short and strong, which shows vitality and drive, as well as a strong ability to overcome health problems.",
                                  "The length and shallowness of your Your Life Line would seem to indicate that your life may have a tendency to be controlled by others.",
                                  "The wavey quality of your Life Line does seem to indicate that you may experience variable health, and that you may not always be very energetic.",
                                  "The double Life Line you may see on your hand is a very lucky marking.  They extra lines are called 'vitality lines' and they indicate increased vitality and positive forces at work in your life.",
                                  "The wide swooping motion of your Life Line indicates strength, enthusiasm and an improved love life.",
                                  "The cramped nature of your Life Line would also seem to indicate a cautious life style, and perhaps a limited love life.",
                                  "When the Life Line crosses the palm, as it does in you case, it indicates a life affected by travel.  Your life may also be heavily influenced by imagination.",
                                  "The little lines you see extending upward from your Life Line are representative of your ability to recuperate.",
                                  "The little lines you see extending downward from your Life Line are indicators of your tendency to waste your energy.",
                                  "The break in your Life Line may be an indicator of an accident or serious illness.  This break is an indication of a sudden change in your life situation.",
                                  "The island in your Life Line could indicate a period of hospitalization or some other kind of recuperation.",
                                  "A chained Life Line indicates various health problems, both physical and emotional. Many people with allergies have such a line as well.",
                                  "Your Head Line is deep, long  and straight, stretching across the palm.  This indicates a logical and direct way of thinking. The straighter the line, the more realistic the thinking, and the deeper the line, the better the memory.",
                                  "Your Head Line is short, which tends to show a tendency towards 'physical' thinking rather than reflection.  You may be impulsive.",
                                  "The light and wavery quality of your Head Line seems to mimic the way you think.  While you don't necessarily lack intellectuality, you don't always think about things in much depth, and sometimes you may have problems concentrating on more than one thing at a time.",
                                  "The short, upcurved quality of your Head Line indicates that you tend to have a short attention span.  Some people may call you a scatterbrain.",
                                  "Your Head Line's line's long upcurving quality of shows you have a retentive memory.",
                                  "A doubled line show increased mental ability.",
                                  "A chained Head Line shows agitation and tension at different points in your life.",
                                  "The break in your line shows a distinct change in your way of thinking.  Sometimes this may even be and indication of a nervous breakdown.",
                                  "If your Head Line is forked near the middle of your palm, it shows an important new interest.  If it is forked at the end, it shows a descent into second childhood.",
                                  "The joining of your Head Line and Life Line at the beginning indicates that your strong sense of mind generally rules over your body. You also look at childhood with a cautious and fearful outlook.",
                                  "Having your Head Line and Heart Line separated shows a love for adventure and an enthusiasm for life.",
                                  "A normal and content love life is represented when the Heart Line starts under the Index Finger as it does on your hand.",
                                  "A slight disregard to the true meaning of love and its responsibilities are indicated by a Heart Line like yours that starts between the middle and index finger.  You tend to easily give your heart away.",
                                  "A selfish and materialistic look at love is characteristic to those like you whose Heart Line start below the middle finger.",
                                  "A long Heart Line like yours, running almost all the way across the palm, represents an idealist in love.  In love you tend to look for those whose status rises above your own, and you have a great respect for them.",
                                  "Your have a short Heart Line.  This shows a lack of interest in the affairs of love and affections. However if your short line is also very strong and deep, then your affections tend to be quite stable.",
                                  "Your double Heart Line shows that you are protected by someone who loves you.",
                                  "The small lines you may see extending upward from your Heart Line are a good sign, as they illustrate happiness in love.",
                                  "Those little lines you see running downward from your Heart Line indicate disappointments in love.",
                                  "The break in you Heart Line indicates an emotional loss.  This can sometimes indicate the end of an affair.",
                                  "Your chained Heart Line is an indication that your life is sometimes bothered by emotional tensions.",
                                  "You posses a square hand.  This is typically the mark of a working, balanced, earthy individual.  Most businessmen who've become successful, and have risen from working with their hands, have square palms.  This type of hand is typically found on people, who are involved in a  practical, materialistic occupation.  They see people usually have solid values and a lot of physical energy.",
                                  "You posses a pointed hand.  This is the hand of someone who appreciates the finer things in life.  You like to be surrounded with art and beauty, and you tend to avoid manual labor.  You are interested in psychic matters, and may even posses a heightened sense of perception.  Many people who poses this type of hand become involved in the cosmetic or hair styling industry.",
                                  "You have a conical hand.  This is often the type of hand shared by people who are more interested in theory than practice.  This is the hand of the imaginative and creative spirit.  Professions of people who share this type of hand usually include teacher, lawyer or artist.",
                                  "You have a spade-shaped hand.  This is the hand of an inventor.  You are probably very good with all things mechanical.  Often those who've forged new paths in science and engineering have a spade-shaped hand.  Women who have this type of hand enjoy do-it-yourself projects (decorating and sewing).  It also gives these women a manual dexterity greater than most men have.",
                                  "The mixed hand is a sign of versatility.  You have a mixed hand which means that you are more likely to be a generalist, instead of a specialist.  You combine creativity and practicality in equal parts.  As far as careers are concerned for the owners of the mixed hand, don't be surprised if you end up as a teacher, a journalist or even on the business side of the creative arts."]
