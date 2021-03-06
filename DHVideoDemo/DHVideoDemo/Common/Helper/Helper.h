//
//  Helper.h
//  
//
//  Created by vernepung on 14-5-6.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static NSDateFormatter *dateFormatter;
@interface Helper : NSObject
#pragma mark 一些常用的公共方法
+ (NSDateFormatter *)dateFormatter;
/**
 *@brief 将对象转化为json字符串
 */
+ (NSString *)jsonStringFromObject:(id)object;
/**
 *@brief 安全的取字典中的值
 */
+ (id)valueForKey:(NSString *)key object:(NSDictionary *)object;
/**
 *@brief 通过URLString获取Scheme的索引
 *@return 如果没找到，则返回-1
 */
+ (NSInteger)getUrlSchemesIndex:(NSString*)URLString;

/**
 @pram postion(key:位置  value:长度)
 */
+(NSMutableAttributedString *)setNSStringCorlor:(NSString *)_content positon:(NSDictionary*)positionDict withColor:(UIColor*)color;
/**
 *@brief 同步日历
 */
+(void)synchronizedToCalendarTitle:(NSString *)title location:(NSString *)location;

/** 获取NSBundele中的资源图片 */
+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName;


#pragma mark 文件系统的操作方法
/** 创建文件夹 */
+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory;

/** 得到用户document中的一个路径 */
+ (NSString*)getPathInUserDocument:(NSString *)fileName;

/** 将文件大小格式化，按照KB\M\G的方式展示*/
+ (NSString *)formatFileSize:(int)fileSize;

/** 文件创建日期 */
+ (NSDate *)dateOfFileCreateWithFolderName:(NSString *)folderName cacheName:(NSString *)cacheName;

/** 统计某个文件的磁盘空间大小 */
+ (int)sizeOfFile:(NSString *)path;

/** 统计某个文件夹的磁盘空间大小 */
+ (int)sizeOfFolder:(NSString*)folderPath;

/** 移除某个文件夹下的所有文件 */
+ (void)removeContentsOfFolder:(NSString *)folderPath;

/** 移除某个文件夹下的所有文件(非变例)并重新创建被删除的文件夹 */
+ (void) deleteContentsOfFolder:(NSString *)folderPath;


#pragma mark 计算字符串尺寸方法
/**
 *@brief 根据字符串获取label的高度
 *@param labelString label的text
 *@param fontSize label的字体大小，以systemFont为标准
 *@param width 最大宽度
 *@param height 最大高度
 */
+ (CGFloat)heightForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontSize withWidth:(CGFloat)width withHeight:(CGFloat)height;

/**
 *@brief 根据字符串获取label的宽度
 *@param labelString label的text
 *@param fontSize label的字体大小，以systemFont为标准
 *@param width 最大宽度
 *@param height 最大高度
 */
+ (CGFloat)widthForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height;

/**
 *@brief 根据字符串获取label的尺寸
 *@param labelString label的text
 *@param font label的字体
 *@param size 限制的最大尺寸
 */
+ (CGSize)sizeForLabelWithString:(NSString *)string withFontSize:(CGFloat)fontsize constrainedToSize:(CGSize)size;



#pragma mark 时间格式转换
/**
 *@brief 获取当前时间戳，并转化为字符串
 **/
+(NSString *)getTimeStamp;
/**
 *@brief 将时间格式字符串按照format格式转化为需要的时间格式字符串
 */
+ (NSString *)formatDateWithString:(NSString *)dateString format:(NSString *)format;
/**
 *@brief 将date按照format格式转化为字符串
 */
+ (NSString *)formatDateWithDate:(NSDate *)date format:(NSString *)format;
/**
 *@brief 将时间戳按照format格式化为字符串
 *@param timeInterval 1970开始的时间戳
 */
+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;
/**
 *@brief 将时间格式字符串转化为date
 */
+ (NSDate *)dateValueWithString:(NSString *)dateStr ByFormatter:(NSString *)formatter;
/**
 *@brief 给出date，返回这个时间点是周几
 */
+ (NSString *)weekdayStringValue:(NSDate*)date;
/**
 *
 *根据日期 返回月份
 */
+ (NSInteger)monthFromDate:(NSDate *)date;

/**
 *@brief 将时间戳转换成时分秒
 */
+(NSString *)getTimeIntervalWithTime:(NSTimeInterval)timeInterval;
/**
 *  @param timeInterval 时间戳
 *
 *  @return 日期
 */
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval withFormatter:(NSString *)formatter;
/**
 *  时间补0
 *
 *  @param str str description
 *
 *  @return return value description
 */
+ (NSString *)fillZeroWithString:(NSString *)str;

+(NSString *)getTwoCharTimeIntervalWithTime:(NSInteger)timeInterval formatStr:(NSString *)formatStr;


#pragma mark 归档，解归档
+ (NSData *)archiverObject:(NSObject *)object forKey:(NSString *)key;
+ (NSObject *)unarchiverObject:(NSData *)archivedData withKey:(NSString *)key;

#pragma mark 从NSUserDefaults取值或存值
+ (id)valueForKey:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key;

#pragma mark 字符串格式化或单位换算
/**
 *@brief 对数字字符串进行友好的格式化，每四个空一格
 */
+ (NSString *)friendFormatString:(NSString *)sourceStr;
/**
 *@brief 去掉小数点后面多余的0并且只保留两位小数
 */
+(NSString *)trimright0:(double )param;
/**
 *@brief 换算距离，大于99km，返回>99km
 *@note 单位为m或km
 */
+ (NSString *)transformMetreToKilometre:(NSString *)meter;//>99km
/**
 *@brief 换算距离，大于99千，返回>99千
 *@note 单位为千
 */
+ (NSString *)transformMetreToKilometreAccurate:(NSString *)meter;
/**
 *@brief 计算开始时间与结束时间中间相隔xx天
 *@param startTime 开始时间
 *@param endTime 结束时间
 */
+(NSString *)getLeftTimeWithStartTime:(double)startTime endTime:(double)endTime;


#pragma mark 系统和设备信息
/**
 *	@brief  获取用户的ADFA
 *
 */
+ (NSString *) getAdvertisingIdentifier;

/**
 *	@brief 获取当前设备类型如ipod，iphone，ipad
 *
 */
+ (NSString *)deviceType;
+ (id)parserJsonData:(id)jsonData;
@end
