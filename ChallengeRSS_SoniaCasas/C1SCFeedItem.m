//
//  C1SCFeedItem.m
//  Challenge1_RSSReader
//
//  Created by Sonia Casas on 18/4/15.
//  Copyright (c) 2015 Sonia Casas. All rights reserved.
//

#import "C1SCFeedItem.h"

@implementation C1SCFeedItem
@synthesize title, link, desc, guid, url, pubDate;

- (id) init {
    if (self = [super init]) {
        
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        desc = [[NSMutableString alloc] init];
        guid = [[NSMutableString alloc] init];
    }
    
    return self;
}

@end
