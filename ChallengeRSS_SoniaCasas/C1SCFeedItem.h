//
//  C1SCFeedItem.h
//  Challenge1_RSSReader
//
//  Created by Sonia Casas on 18/4/15.
//  Copyright (c) 2015 Sonia Casas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C1SCFeedItem : NSObject {
    
    NSMutableString *title; // Feed title
    NSMutableString *link; // Feed link
    NSMutableString *desc; // Feed description
    NSMutableString *guid; //Feed guid
    NSDate *pubDate; // Feed publication date
    NSURL *url; // Feed url
    
}

@property (nonatomic, copy) NSMutableString *title;
@property (nonatomic, copy) NSMutableString *link;
@property (nonatomic, copy) NSMutableString *desc;
@property (nonatomic, copy) NSMutableString *guid;
@property (nonatomic, copy) NSDate *pubDate;
@property (nonatomic, copy) NSURL *url;

@end
