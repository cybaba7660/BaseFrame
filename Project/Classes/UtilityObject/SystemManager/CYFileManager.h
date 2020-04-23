//
//  CYFileManager.h
//  Project
//
//  Created by Chenyi on 2018/2/7.
//  Copyright © 2018年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYFileManager : NSObject

/**
 获取Document路径

 @return Document路径
 */
+ (NSString *)getDocumentPath;

/**
 获取Library路径

 @return Library路径
 */
+ (NSString *)getLibraryPath;

/**
 获取应用程序路径

 @return 应用程序路径
 */
+ (NSString *)getApplicationPath;

/**
 获取Cache路径

 @return Cache路径
 */
+ (NSString *)getCachePath;

/**
 获取Temp路径

 @return Temp路径
 */
+ (NSString *)getTempPath;

/**
 判断文件是否存在于某个路径中

 @param filePath 文件路径
 @return YES:存在 NO:不存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)filePath;

/**
 从某个路径中移除文件

 @param filePath 文件路径
 @return YES:成功 NO:失败
 */
+ (BOOL)removeFileAtPath:(NSString *)filePath;

/**
 从URL路径中移除文件

 @param fileURL 文件路径
 @return YES:成功 NO:失败
 */
- (BOOL)removeFileOfURL:(NSURL *)fileURL;

/**
 创建文件路径

 @param dirPath 文件路径
 @return YES:成功 NO:失败
 */
+ (BOOL)creatDirectoryWithPath:(NSString *)dirPath;

/**
 创建文件

 @param filePath 文件路径
 @return YES:成功 NO:失败
 */
+ (BOOL)creatFileWithPath:(NSString *)filePath;

/**
 保存文件

 @param filePath 文件路径
 @param data 数据对象
 @return YES:成功 NO:失败
 */
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;

/**
 追加写文件

 @param data 数据对象
 @param path 文件路径
 @return YES:成功 NO:失败
 */
+ (BOOL)appendData:(NSData *)data withPath:(NSString *)path;

/**
 获取文件

 @param filePath 文件路径
 @return 数据对象
 */
+ (NSData *)getFileData:(NSString *)filePath;

/**
 读取文件

 @param filePath 文件路径
 @param startIndex 数据起始位置
 @param length 数据长度
 @return 数据对象
 */
+ (NSData *)getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;

/**
 移动文件

 @param fromPath 进行移动的文件路径
 @param toPath 目的文件路径
 @return YES:成功 NO:失败
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 拷贝文件

 @param fromPath 被COPY的文件路径
 @param toPath COPY目的地路径
 @return YES:成功 NO:失败
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 获取文件夹下文件列表

 @param path 文件路径
 @return 文件列表
 */
+ (NSArray *)getFileListInFolderWithPath:(NSString *)path;

/**
 获取文件大小

 @param path 文件路径
 @return 文件大小 单位:KB
 */
+ (long long)getFileSizeWithPath:(NSString *)path;
//
/**
 获取文件创建时间

 @param path 文件路径
 @return 创建时间
 */
+ (NSString *)getFileCreatDateWithPath:(NSString *)path;
/**
 获取文件所有者

 @param path 文件路径
 @return 所有者
 */
+ (NSString *)getFileOwnerWithPath:(NSString *)path;

/**
 获取文件更改日期

 @param path 文件路径
 @return 更改日期
 */
+ (NSString *)getFileChangeDateWithPath:(NSString *)path;
@end
