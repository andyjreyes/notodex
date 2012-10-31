//
//  NotebooksListViewController.h
//  Notodex
//
//  Created by Andy Reyes on 10/14/12.
//  Copyright (c) 2012 Andy Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"

@protocol FGalleryViewControllerDelegate;

@interface NotebooksListViewController : UITableViewController <FGalleryViewControllerDelegate>
@property (nonatomic) NSInteger numberOfNotebooks;
@property (strong, nonatomic) NSString *myText;
@property (strong, nonatomic) NSMutableArray *networkCaptions;
@property (strong, nonatomic) NSMutableArray *localCaptions;
@property (strong, nonatomic) NSMutableArray *networkImages;
@property (strong, nonatomic) NSMutableArray *localImages;
@property (strong, nonatomic) FGalleryViewController *networkGallery;
@property (strong, nonatomic) FGalleryViewController *localGallery;

@end
