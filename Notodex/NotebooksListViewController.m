//
//  NotebooksListViewController.m
//  Notodex
//
//  Created by Andy Reyes on 10/14/12.
//  Partial code snippets from Grant Davis.
//  Grant's code here: https://github.com/gdavis/FGallery-iPhone
//  Copyright (c) 2012 Andy Reyes. All rights reserved.
//

#import "NotebooksListViewController.h"
#import "EvernoteSDK.h"

#define MAX_PHOTOS_TO_RETURN 500

@interface NotebooksListViewController ()

@end

@implementation NotebooksListViewController

@synthesize numberOfNotebooks = _numberOfNotebooks;
@synthesize networkImages = _networkImages;
@synthesize networkCaptions = _networkCaptions;
@synthesize networkGallery = _networkGallery;
@synthesize localImages = _localImages;
@synthesize localCaptions = _localCaptions;
@synthesize localGallery = _localGallery;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self.refreshControl addTarget:self
                            action:@selector(refreshList)
                  forControlEvents:UIControlEventValueChanged];
    
    _networkImages = [[NSMutableArray alloc] initWithObjects:nil];
    _networkCaptions = [[NSMutableArray alloc] initWithObjects:nil];
    _localImages = [[NSMutableArray alloc] initWithObjects:nil];
    _localCaptions = [[NSMutableArray alloc] initWithObjects:nil];
    
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) refreshList
{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        _numberOfNotebooks = [notebooks count];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
                                failure:^(NSError *error) {
                                    NSLog(@"error %@", error);
                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfNotebooks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotebookListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks){
        
        NSDate *dateModified = [NSDate dateWithTimeIntervalSince1970:[[notebooks objectAtIndex:indexPath.row] serviceUpdated]/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; //TODO v2.0: Choose based on device locale
        [dateFormatter setLocale:usLocale];
        
        cell.textLabel.text = [[notebooks objectAtIndex:indexPath.row] name];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:dateModified];
    }
                                failure:^(NSError *error) {
                                    NSLog(@"error %@", error);
                                }];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num = 0;
    if( gallery == _networkGallery ) {
        num = [_networkImages count];
    }
    else if( gallery == _localGallery){
        num = [_localImages count];
    }
    
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    if( gallery == _localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption = @"";
    if( gallery == _localGallery ) {
        caption = [_localCaptions objectAtIndex:index];
    }
    else if( gallery == _networkGallery ) {
        caption = [_networkCaptions objectAtIndex:index];
    }
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [_localImages objectAtIndex:index];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [_networkImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[_localGallery removeImageAtIndex:[_localGallery currentIndex]];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    // remove previous images, otherwise we would accumulate images
    [_networkImages removeAllObjects];
    [_networkCaptions removeAllObjects];
    
    // get notebooks
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks)
     {
         // get only the notebook the user selected
         EDAMNotebook *singleNotebook = [notebooks objectAtIndex:indexPath.row];
         
         // get "business card*" tag GUIDs (TODO v2.0: Use regex comparison to get "business card*" or user-defined tags)
         [noteStore listTagsByNotebookWithGuid:singleNotebook.guid success:^(NSArray *tags)
          {
              NSMutableArray *tagGuids = [[NSMutableArray alloc] initWithObjects:nil];
              for (EDAMTag *singleTag in tags)
              {
                  if ([singleTag.name caseInsensitiveCompare:@"business card"] == NSOrderedSame || [singleTag.name caseInsensitiveCompare:@"business cards"] == NSOrderedSame)
                  {
                      [tagGuids addObject:singleTag.guid];
                  }
              }
              
              // get notes with "business card*" filter
              EDAMNoteFilter *filter = [[EDAMNoteFilter alloc] initWithOrder:1
                                                                   ascending:NO
                                                                       words:NO
                                                                notebookGuid:singleNotebook.guid
                                                                    tagGuids:tagGuids
                                                                    timeZone:nil
                                                                    inactive:NO];
              __block NSInteger offset = 0; //for pagination when supported, v2.0
              [noteStore findNotesWithFilter:filter
                                      offset:offset
                                    maxNotes:MAX_PHOTOS_TO_RETURN
                                     success:^(EDAMNoteList *noteList)
               {
                   for (EDAMNote *singleNote in noteList.notes)
                   {
                       for (EDAMResource *singleResource in singleNote.resources)
                       {
                           // only get png and jpeg images, gif can be enabled if so desired
                           if ([singleResource.mime isEqualToString:@"image/png"] || [singleResource.mime isEqualToString:@"image/jpeg"])
                           {
                               // resourceWebURL is the direct link to the full size image on user's Evernote
                               NSString *resourceWebURL = [session.webApiUrlPrefix stringByAppendingString:@"/res/"];
                               NSString *authToken = [@"?auth=" stringByAppendingString:session.authenticationToken];
                               resourceWebURL = [[resourceWebURL stringByAppendingString:singleResource.guid] stringByAppendingString:authToken];
                               
                               [_networkImages addObject:resourceWebURL];
                               [_networkCaptions addObject:singleNote.title];
                           }
                           
                       }
                       offset++;
                   }
                   // gallery is complete, push gallery view controller
                   _networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
                   [self.navigationController pushViewController:_networkGallery animated:YES];
                   [_networkGallery release];
               }
                                     failure:^(NSError *error) {
                                         NSLog(@"error %@", error);
                                     }];
          }
                                       failure:^(NSError *error) {
                                           NSLog(@"error %@", error);
                                       }];
     }
                                failure:^(NSError *error) {
                                    NSLog(@"error %@", error);
                                }];
}

@end
