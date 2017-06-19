//
//  BLEMacro.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#ifndef BLEMacro_h
#define BLEMacro_h

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define scaleBy320(x) ((int)(SCREEN_WIDTH)*(x)/320)
#define DRAW_LINE_WIDTH (1/[[UIScreen mainScreen] scale])

/******************************图片******************************/

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
//定义UIImage对象
#define ImageNamed(name) [UIImage imageNamed:name]

/******************************图片******************************/




/******************************颜色类******************************/
// 16进制颜色
#define HEXCOLOR(rgbValue) HEXACOLOR(rgbValue, 1.f)
#define HEXACOLOR(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// RGB颜色
#define RGBCOLOR(r,g,b)    RGBACOLOR(r, g, b, 1.f)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RDP_SEPARATOR_COLOR  HEXCOLOR(0xd8d9dc)

#define BLE_TITLE_COLOR  HEXCOLOR(0x333333)
#define BLE_CONTENT_COLOR  HEXCOLOR(0x666666)
/******************************颜色类******************************/

/******************************服务******************************/
#define BLE_CUSTOM_SERVICER @"56EF"
#define BLE_CUSTOM_READ_CHARACTERISTIC @"34E2"
#define BLE_CUSTOM_WRITE_CHARACTERISTIC @"34E1"

/******************************服务******************************/



#endif /* BLEMacro_h */
