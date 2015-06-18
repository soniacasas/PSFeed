//
//  C1SCDeatilRSSViewController.h
//  ChallengeRSS_SoniaCasas
//
//  Created by Sonia Casas on 19/4/15.
//  Copyright (c) 2015 Sonia Casas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C1SCFeedItem.h"

@interface C1SCDeatilRSSViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) C1SCFeedItem *feedItem;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
