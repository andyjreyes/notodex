//
//  NotodexViewController.m
//  Notodex
//
//  Modified and adapted by Andy Reyes on 10/14/12.
//  Created by Matthew McGlincy on 3/17/12.
//  Matthew's code here: https://github.com/evernote/evernote-sdk-ios
//  Copyright (c) 2012 Andy Reyes. All rights reserved.
//

#import "EvernoteSDK.h"
#import "NotebooksListViewController.h"
#import "NotodexViewController.h"

@interface NotodexViewController ()

@end

@implementation NotodexViewController

@synthesize userLabel;
@synthesize listNotebooksButton;
@synthesize authenticateButton;
@synthesize logoutButton;
@synthesize notebookCount = _notebookCount;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateButtonsForAuthentication];
}

- (void)viewDidUnload
{
    [self setListNotebooksButton:nil];
    [self setUserLabel:nil];
    [self setAuthenticateButton:nil];
    [self setLogoutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)authenticate:(id)sender
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [session authenticateWithViewController:self completionHandler:^(NSError *error) {
        if (error || !session.isAuthenticated) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Could not authenticate"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
        } else {
            [self updateButtonsForAuthentication];
        }
    }];
}

- (void)showUserInfo
{
    EvernoteUserStore *userStore = [EvernoteUserStore userStore];
    [userStore getUserWithSuccess:^(EDAMUser *user) {
        self.userLabel.text = [@"Signed in as " stringByAppendingString:user.username];
    }
                          failure:^(NSError *error) {
                              NSLog(@"error %@", error);
                          }];
}

- (IBAction)listNotes:(id)sender {
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        _notebookCount = [notebooks count];
        [self performSegueWithIdentifier:@"ShowNotebooksList" sender:sender];
    }
                                failure:^(NSError *error) {
                                    NSLog(@"error %@", error);
                                }];
}

- (void)updateButtonsForAuthentication
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    
    if (session.isAuthenticated) {
        self.authenticateButton.enabled = NO;
        self.authenticateButton.alpha = 0.0;
        self.listNotebooksButton.enabled = YES;
        self.listNotebooksButton.alpha = 1.0;
        self.logoutButton.enabled = YES;
        self.logoutButton.alpha = 1.0;
        [self showUserInfo];
    } else {
        self.authenticateButton.enabled = YES;
        self.authenticateButton.alpha = 1.0;
        self.listNotebooksButton.enabled = NO;
        self.listNotebooksButton.alpha = 0.0;
        self.logoutButton.enabled = NO;
        self.logoutButton.alpha = 0.0;
        self.userLabel.text = @"Please sign in";
    }
}

- (IBAction)logout:(id)sender {
    [[EvernoteSession sharedSession] logout];
    [self updateButtonsForAuthentication];
}

- (void)dealloc {
    [listNotebooksButton release];
    [userLabel release];
    [authenticateButton release];
    [logoutButton release];
    [super dealloc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowNotebooksList"])
    {
        NotebooksListViewController *notebooksListVC = (NotebooksListViewController *) segue.destinationViewController;
        [notebooksListVC setNumberOfNotebooks:_notebookCount];
    }
}

@end
