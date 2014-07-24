//
//  ADActivityViewController.h
//  BLE2
//
//  Created by Chenchen Zheng on 1/7/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCBPGraphView.h"
//#import "WCBPPulseGraphView.h"
#import "WCTouchView.h"

@interface ADActivityViewController : UIViewController <WCBPDataSource, WCTouchSource>

@end
