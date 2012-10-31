//
//  NotodexViewController.h
//  Notodex
//
//  Modified and adapted by Andy Reyes on 10/14/12.
//  Created by Matthew McGlincy on 3/17/12.
//  Matthew's code here: https://github.com/evernote/evernote-sdk-ios
//  Copyright (c) 2012 Andy Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotodexViewController : UIViewController

- (IBAction)authenticate:(id)sender;
- (IBAction)listNotes:(id)sender;
- (IBAction)logout:(id)sender;
@property (nonatomic) NSInteger notebookCount;
@property (retain, nonatomic) IBOutlet UILabel *userLabel;
@property (retain, nonatomic) IBOutlet UIButton *listNotebooksButton;
@property (retain, nonatomic) IBOutlet UIButton *authenticateButton;
@property (retain, nonatomic) IBOutlet UIButton *logoutButton;

@end
