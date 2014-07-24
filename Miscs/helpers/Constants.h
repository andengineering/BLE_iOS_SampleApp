//
//  Constants.h
//  WellnessConnected
//
//  Created by Chenchen Zheng on 3/22/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

#define SYSTOLIC @"Systolic"
#define DIASTOLIC @"Diastolic"
#define PULSE @"Pulse"
#define MAP @"MAP"
#define HEIGHT @"Height"
#define WEIGHT @"Weight"
#define BMI @"BMI"
#define MEASURMENTID @"measurmentId"
#define MEASUREDDATE @"Measured Date"
#define MANUALEDIT @"manualEdit"

#define HELVETICA @"Helvetica"
#define HELVETICABOLD @"Helvetica-Bold"
#define HELVETICA @"Helvetica"

typedef NS_ENUM(NSUInteger, dataType) {
  BPSysDia,
  BPPulse,
  WSWeight,
  WSBMI,
  BCAWeight,
  BCAFat
};

