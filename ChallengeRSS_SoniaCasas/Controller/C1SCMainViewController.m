//
//  C1SCMainViewController.m
//  ChallengeRSS_SoniaCasas
//
//  Created by Sonia Casas on 18/4/15.
//  Copyright (c) 2015 Sonia Casas. All rights reserved.
//

#import "C1SCMainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "C1SCFeedItem.h"
#import "C1SCDeatilRSSViewController.h"
#import "C1SCMainTableViewCell.h"

@interface C1SCMainViewController () {
    C1SCFeedItem *feedItem;
    NSMutableArray *feeds;
}

@property NSString *tmpInnerTagText;
@property NSString *reuseIdentifier;

@end

@implementation C1SCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reuseIdentifier = @"feedCell";
    [self.navigationItem setTitle:@"Loading RSS"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    feeds = [[NSMutableArray alloc] init];
    [self performRetrieveFeed];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) performRetrieveFeed {
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://webassets.scea.com/pscomauth/groups/public/documents/webasset/rss/playstation/Games_PS3.rss"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"application/rss+xml"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving RSS"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        UIApplication *application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = NO;
        
    }];
    
    [operation start];
}

#pragma mark - Parsing lifecycle

- (void)startTheParsingProcess:(NSData *)parserData
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:parserData]; //parserData passed to NSXMLParser delegate which starts the parsing process
    
    [parser setDelegate:self];
    [parser parse]; // starts the event-driven parsing operation.
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    self.tmpInnerTagText = elementName;
    
    if ([self.tmpInnerTagText isEqualToString:@"item"]) {
        
        
        feedItem    = [[C1SCFeedItem alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([self.tmpInnerTagText isEqualToString:@"title"]) {
        [feedItem.title appendString:string];
    } else if ([self.tmpInnerTagText isEqualToString:@"link"]) {
        [feedItem.link appendString:string];
    } else if ([self.tmpInnerTagText isEqualToString:@"description"]) {
        [feedItem.desc appendString:string];
    } else if ([self.tmpInnerTagText isEqualToString:@"guid"]) {
        [feedItem.guid appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        
        
        [feeds addObject:feedItem ];
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    self.navigationItem.title = @"RSS Reader";
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Paser Error = %@", parseError);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving RSS"
                                                        message:[parseError localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self mainTableCellAtIndexPath:indexPath];
}

- (C1SCMainTableViewCell *)mainTableCellAtIndexPath:(NSIndexPath *)indexPath {
    C1SCMainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    [self configureMainTableCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureMainTableCell:(C1SCMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    C1SCFeedItem *actualItem = [feeds objectAtIndex:[indexPath row]];
    [self setTitleForCell:cell item:actualItem];
    [self setSubtitleForCell:cell item:actualItem];
}

- (void)setTitleForCell:(C1SCMainTableViewCell *)cell item:(C1SCFeedItem *)item {
    NSString *title = item.title ?: NSLocalizedString(@"[No Title]", nil);
    [cell.titleLabel setText:title];
}

- (void)setSubtitleForCell:(C1SCMainTableViewCell *)cell item:(C1SCFeedItem *)item {
    NSString *subtitle = item.desc;
    
    NSArray *allSentences = [self fullSentencesFromText:subtitle];
    
    [cell.subTitleLAbel setText:[allSentences objectAtIndex:0]];
}

- (NSArray *) fullSentencesFromText: (NSString *)text {
    NSMutableArray *results = [NSMutableArray array];
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationBySentences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [results addObject:substring];
    }];
    return results;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForMainTableCellAtIndexPath:indexPath];
}

- (CGFloat)heightForMainTableCellAtIndexPath:(NSIndexPath *)indexPath {
    static C1SCMainTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    });
    
    [self configureMainTableCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        C1SCFeedItem *selectedFeedItem = [feeds objectAtIndex:indexPath.row];
        
        C1SCDeatilRSSViewController *destinationViewController = [segue destinationViewController];
        
        [destinationViewController setFeedItem:selectedFeedItem];
        
    }
}


@end
