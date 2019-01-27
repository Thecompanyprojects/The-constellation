//
//  XYZodiacSelectionManager.h
//  Horoscope
//
//  Created by zhang ming on 2018/4/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYZodiacSelectionManagerDelegate <NSObject>
- (void)zodiacSelectionDidChange:(NSInteger)index;
@end

@interface TTZodiacSelectionManager : NSObject

@property (nonatomic, weak) id <XYZodiacSelectionManagerDelegate> delegate;
@property (nonatomic, assign) NSInteger zodiacIndex;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) BOOL showZodiacSelection;

- (void)saveZodiacIdToKeychain;

@end
