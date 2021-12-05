//
//  WebPDataDecoder.h
//  Nuke-AVIF-Plugin iOS
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

#import "WebPImageMacros.h"

#if WEBP_PLUGIN_MAC
#import <AppKit/AppKit.h>
#define Image   NSImage
#else
#import <UIKit/UIKit.h>
#define Image   UIImage
#endif

@interface WebPDataDecoder : NSObject

- (nullable Image *)incrementallyDecodeData:(nonnull NSData *)data;
- (nullable Image *)decodeData:(nonnull NSData *)data;

@end
