//
//  Helper.m
//
//
//  Created by vernepung on 14-5-6.
//

#import "Helper.h"
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <objc/runtime.h>
#import  <CommonCrypto/CommonCryptor.h>
#import <EventKit/EventKit.h>
#import <AdSupport/ASIdentifierManager.h>
@interface Helper(){
    
}
@end

@implementation Helper

/**
 *	@brief	获取当前时间戳
 *
 *	@return	 当前时间戳
 */
+(NSString *)getTimeStamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName {
    if(fileName) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
        path = [NSString stringWithFormat:@"%@@2x.%@",path,[fileName pathExtension]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            path = nil;
        }
        
        if(!path) {
            path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        }
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

+ (NSString *)jsonStringFromObject:(id)object{
    if([NSJSONSerialization isValidJSONObject:object]){
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"";
}

+ (id)valueForKey:(NSString *)key object:(NSDictionary *)object{
    if([object isKindOfClass:[NSDictionary class]]){
        return [object objectForKey:key];
    }
    return nil;
}

/**
 *	@brief  获取用户的ADFA
 *
 */
+ (NSString *) getAdvertisingIdentifier{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
/**
 *	@brief 获取当前设备类型如ipod，iphone，ipad
 *
 */
+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory {
    NSString *path = nil;
    if(isDirectory) {
        path = folderPath;
    } else {
        path = [folderPath stringByDeletingLastPathComponent];
    }
    
    if(folderPath && [[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError *error = nil;
        BOOL ret;
        
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error];
        if(!ret && error) {
            NSLog(@"create folder failed at path '%@',error:%@,%@",folderPath,[error localizedDescription],[error localizedFailureReason]);
            return NO;
        }
    }
    
    return YES;
}

+ (NSString*)getPathInUserDocument:(NSString*) aPath{
    NSString *fullPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0)
    {
        fullPath = (NSString *)[paths objectAtIndex:0];
        if(aPath != nil && [aPath compare:@""] != NSOrderedSame)
        {
            fullPath = [fullPath stringByAppendingPathComponent:aPath];
        }
    }
    
    return fullPath;
}

+ (NSString *)formatFileSize:(int)fileSize {
    float size = fileSize;
    //    if (fileSize < 1023) {
    //        return([NSString stringWithFormat:@"%i bytes",fileSize]);
    //    }
    
    size = size / 1024.0f;
    if (size < 1023) {
        return([NSString stringWithFormat:@"%1.2f KB",size]);
    }
    
    size = size / 1024.0f;
    if (size < 1023) {
        return([NSString stringWithFormat:@"%1.2f MB",size]);
    }
    
    size = size / 1024.0f;
    return [NSString stringWithFormat:@"%1.2f GB",size];
}

+ (int)sizeOfFile:(NSString *)path {
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    
    if(!error) {
        return (int)[attributes fileSize];
    }
    
    return 0;
}

+ (NSDate*)dateOfFileCreateWithFolderName:(NSString *)folderName cacheName:(NSString *)cacheName
{
    NSString *folder = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:folderName];
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    
    if(!error) {
        return [attributes objectForKey:NSFileCreationDate];
    }
    
    return nil;
}

+ (int)sizeOfFolder:(NSString*)folderPath {
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    NSEnumerator *enumerator = [contents objectEnumerator];
    int totalFileSize = 0;
    
    NSString *path = nil;
    while (path = [enumerator nextObject]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&error];
        totalFileSize += [attributes fileSize];
    }
    
    return totalFileSize;
}

+ (void)removeContentsOfFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager subpathsAtPath:folderPath];
    NSEnumerator *enumerator = [contents objectEnumerator];
    
    NSString *file;
    while (file = [enumerator nextObject]) {
        NSString *path = [folderPath stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (void) deleteContentsOfFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:folderPath error:nil];
    
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSInteger)getUrlSchemesIndex:(NSString*)URLString  {
    //    <?xml version="1.0" encoding="UTF-8"?>
    //    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    //    <plist version="1.0">
    //    <array>
    //    <string>QQ41E57E6E</string>
    //    <string>tencent1105559150</string>
    //    <string>wx4ce560f0c26d3318</string>
    //    <string>teacherSecretary</string>
    //    </array>
    //    </plist>
    
    NSArray *appDeleteArray = @[@"QQ41E57E6E",@"tencent1105559150",@"wx4ce560f0c26d3318",@"teacherSecretary"];
    NSInteger index = -1;
    NSArray *schemesArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if ([schemesArray count] > 0) {
        NSDictionary *dic = [schemesArray objectAtIndex:0];
        schemesArray = [dic objectForKey:@"CFBundleURLSchemes"];
        NSAssert(appDeleteArray.count == schemesArray.count, @"schemes 数量错误,请确认Schemes个数，并且确认Appdelete中的url拦截下标是否与新增后的schemes对应");
        int i = 0;
        for (NSString *schemesName in schemesArray) {
            if([URLString hasPrefix:schemesName]){
                return index = i;
                break;
            }
            i ++;
        }
    }
    return index;
}
#pragma mark alert
+ (CGFloat)widthForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    if(labelString.length == 0){
        return 0.0;
    }
    CGSize size = CGSizeMake(width, height);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName,nil];
    CGSize actualsize = [labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    //得到的宽度为0，返回最大宽度
    if(actualsize.width == 0){
        return width;
    }
    
    return actualsize.width;
}

+ (CGFloat)heightForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName,nil];
    CGSize actualsize = [labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading  attributes:tdic context:nil].size;
    return actualsize.height;
}

+ (CGSize)sizeForLabelWithString:(NSString *)string withFontSize:(CGFloat)fontsize constrainedToSize:(CGSize)size{
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize actualsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading  attributes:tdic context:nil].size;
    return actualsize;
}

/**
 @pram postion(key:位置  value:长度)
 */
+(NSMutableAttributedString *)setNSStringCorlor:(NSString *)_content positon:(NSDictionary*)positionDict withColor:(UIColor*)color
{
    //    NSString *endLength = [NSString stringWithFormat:@"%d",endNum];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_content];
    for (int i=0;i<positionDict.allKeys.count;i++) {
        NSString* key = positionDict.allKeys[i];
        NSString* val = positionDict[key];
        [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([key intValue],[val intValue])];
    }
    return str;
}

+(NSString *)getLeftTimeWithStartTime:(double)startTime endTime:(double)endTime {
    double timeInterval = endTime - startTime;
    NSInteger secondsInDay = 24*60*60;
    NSInteger day = (NSInteger)timeInterval/secondsInDay;
    //    NSInteger hour = (timeInterval - day*secondsInDay)/(60*60);
    //    NSInteger mini = (timeInterval - day*secondsInDay - hour*60*60)/60;
    //    NSInteger second = timeInterval - day*secondsInDay - hour*60*60 - mini*60;
    return [NSString stringWithFormat:@"%zd天",day];
}

+ (NSString *)transformMetreToKilometre:(NSString *)meter {
    
    if ([meter isEqualToString:@""] || !meter) {
        return @"";
    }
    
    NSInteger tmpDistance = [[NSString stringWithFormat:@"%1.0f", [meter doubleValue]] intValue];
    if (0 <= tmpDistance && tmpDistance < 1000) {
        return [NSString stringWithFormat:@"%zdm",tmpDistance];
    } else if (tmpDistance <= 99000) {
        return [NSString stringWithFormat:@"%zd.%zdkm",tmpDistance/1000,(tmpDistance%1000)/100];
    }
    else{
        return @">99km";
    }
    return nil;
}
+ (NSString *)transformMetreToKilometreAccurate:(NSString *)meter
{
    if ([meter isEqualToString:@""] || !meter) {
        return @"";
    }
    
    NSInteger tmpDistance = [[NSString stringWithFormat:@"%1.0f", [meter doubleValue]] intValue];
    if (0 <= tmpDistance && tmpDistance < 1000) {
        return [NSString stringWithFormat:@"%zd",tmpDistance];
    } else if (tmpDistance <= 99000) {
        return [NSString stringWithFormat:@"%zd.%zd千",tmpDistance/1000,(tmpDistance%1000)/100];
    }
    else{
        return @">99千";
    }
    return nil;
}


#pragma mark -new
+ (NSDateFormatter *)dateFormatter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    });
    return dateFormatter;
}
+ (NSString *)formatDateWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:format];
    NSString *result = [dateFormatter stringFromDate:date];
    
    return result;
}
+ (NSString *)formatDateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *d = [dateFormatter dateFromString:dateString];
    
    return [Helper formatDateWithDate:d format:format];
}

+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self formatDateWithDate:date format:format];
}

+ (NSDate *)dateValueWithString:(NSString *)dateStr ByFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *)weekdayStringValue:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int weekday=(int)[comps weekday];
    switch (weekday)
    {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSInteger)monthFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return [comps month];
}

+(NSString *)getTimeIntervalWithTime:(NSTimeInterval)timeInterval{
    
    NSInteger intTime = timeInterval;
    NSInteger seconds = intTime % 60;
    NSInteger minutes = (intTime / 60) % 60;
    NSInteger hours = (intTime / 3600);
    NSString *timeStr = [NSString stringWithFormat:@"%2zd小时%2zd分%2zd秒", hours, minutes, seconds];
    return timeStr;
}
#warning 错误！！！！
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeInterval withFormatter:(NSString *)formatter{
    //waring
    if (timeInterval >= 0) {
        if (formatter.length <= 0) {
            formatter = @"yyyy-MM-dd HH:mm";
        }
        NSDateFormatter *inputFormatter = [self dateFormatter];
        NSString *timeString = [Helper formatTimeInterval:timeInterval format:formatter];
                [inputFormatter setLocale:[NSLocale currentLocale]];
        //        [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                [inputFormatter setDateFormat:formatter];
        
        NSDate* date = [inputFormatter dateFromString:[timeString copy]];
        return date;
    }
    return nil;
}

/**
 *  时间补0
 *
 *  @param str str description
 *
 *  @return return value description
 */
+ (NSString *)fillZeroWithString:(NSString *)str
{
    if (str && str.length == 1)
    {
        return [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}


+(NSString *)getTwoCharTimeIntervalWithTime:(NSInteger)timeInterval formatStr:(NSString *)formatStr{
    NSInteger seconds = labs(timeInterval % 60);
    NSString *secondStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",seconds]];
    NSInteger minutes = labs((timeInterval / 60) % 60);
    NSString *minuteStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",minutes]];
    NSInteger hours = timeInterval / 3600;
    NSString *hourStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",hours]];
    NSString *timeStr = [NSString stringWithFormat:formatStr, hourStr, minuteStr, secondStr];
    return timeStr;
}


+(NSString *)trimright0:(double )param
{
    NSString *str = [NSString stringWithFormat:@"%.2lf",param];
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        //        return [NSString stringWithFormat:@"%@0", str];
        return  [str substringToIndex:[str length]-1];
    }
    else
    {
        return str;
    }
}

+ (NSData *)archiverObject:(NSObject *)object forKey:(NSString *)key {
    if(object == nil) {
        return nil;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    return data;
}

+ (NSObject *)unarchiverObject:(NSData *)archivedData withKey:(NSString *)key {
    if(archivedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
    NSObject *object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return object;
}

+(void)synchronizedToCalendarTitle:(NSString *)title location:(NSString *)location{
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    
                    // display error message here
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = [[NSDate alloc]init ];
                    event.endDate   = [[NSDate alloc]init ];
                    event.allDay = YES;
                    
                    //添加提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                }
            });
        }];
    }
    else
    {
        //4.0和5.0通过下述方式添加
        
        //保存日历
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title     = title;
        event.location = location;
        
        NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
        [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        event.startDate = [[NSDate alloc]init ];
        event.endDate   = [[NSDate alloc]init ];
        event.allDay = YES;
        
        
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        NSLog(@"保存成功");
        
    }
    
}

#pragma mark-
+ (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)friendFormatString:(NSString *)sourceStr{
    if(![sourceStr isKindOfClass:[NSString class]]){
        return nil;
    }
    //各四个字符插入一个空字符
    NSMutableString *targetStr = [NSMutableString stringWithString:sourceStr];
    for(int i = 4, k = 4; i < sourceStr.length; i += 4, k = i+1){
        [targetStr insertString:@" " atIndex:k];
    }
    return [NSString stringWithFormat:@"%@", targetStr];
}

/**
 *	@brief	将json数据转换成id
 *
 *	@param data 数据
 *
 *	@return	 id类型的数据
 */
+ (id)parserJsonData:(id)jsonData{
    
    NSError *error;
    id jsonResult = nil;
    if (jsonData&&[jsonData isKindOfClass:[NSData class]])
    {
        jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    if (jsonResult != nil && error == nil)
    {
        return jsonResult;
    }else{
        // 解析错误
        return nil;
    }
}

@end
