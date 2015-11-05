//
//  ViewController1.h
//  TM
//
//  Created by City--Online on 15/11/5.
//  Copyright © 2015年 City--Online. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HeadRefReshBlock)();

@interface ViewController1 : UIViewController
@property (nonatomic,copy) HeadRefReshBlock headRefReshBlock;
@end
