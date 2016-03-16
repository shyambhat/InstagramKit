//
//    Copyright (c) 2015 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKCollectionViewController.h"
#import "InstagramKit.h"
#import "IKCollectionCell.h"
#import "InstagramMedia.h"
#import "IKMediaViewController.h"
#import "IKLoginViewController.h"

#define kNumberOfCellsInARow 3
#define kFetchItemsCount 15

@interface IKCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak) InstagramEngine *instagramEngine;

@end


@implementation IKCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    [self updateCollectionViewLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
    
    [self loadMedia];
}


/**
 Once the view has been added to the view hierarchy, if the
 user is not logged in, we'll show the appropieta authentication view.
 @discussion This check is here and not in viewDidLoad:, to avoid
 a hierarchy window warning.
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.instagramEngine isSessionValid]) [self login];
}


/**
 This method prepares the view and loads (if the user is authenticated)
 the user recent media.
 */
- (void)loadMedia
{
    self.currentPaginationInfo = nil;
    
    [self setTitle:@"My Media"];
    [self.navigationItem.leftBarButtonItem setTitle:@"Log out"];
    [self.navigationItem.rightBarButtonItem setEnabled: NO];
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
    
    if ([self.instagramEngine isSessionValid]) [self requestSelfRecentMedia];
}


#pragma mark - API Requests -


/**
 Calls InstagramKit's helper method to fetch recent Media in the authenticated user's.
 @discussion The self.currentPaginationInfo object is updated on each successful call
 and it's updated nextMaxId is passed as a parameter to the next paginated request. Once
 the paginationInfo received is 'nil', there is no more media to load.
 */
- (void)requestSelfRecentMedia
{
    [self.instagramEngine getSelfRecentMediaWithCount:kFetchItemsCount
                                                maxId:self.currentPaginationInfo.nextMaxId
                                              success:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                                  
                                                  self.currentPaginationInfo = paginationInfo;
                                                  // Disable 'More' navigation item when there is no more pagination.
                                                  [self.navigationItem.rightBarButtonItem setEnabled:(paginationInfo) ? YES : NO];
                                                  
                                                  // Prevent EXC_BAD_ACCESS when the media array received is empty.
                                                  if (media.count > 0)
                                                  {
                                                      [self.mediaArray addObjectsFromArray:media];
                                                      [self.collectionView reloadData];
                                                      
                                                      [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                                                  }
                                                  
                                              } failure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Request Self Recent Media Failed");
                                              }];
}


/**
 Invoked when user taps the 'More' navigation item.
 @discussion The requestSelfRecentMedia method is called with updated pagination parameters (nextMaxId).
 */
- (IBAction)moreTapped:(id)sender
{
    [self requestSelfRecentMedia];
}


/**
 Invoked when user taps the left navigation item. It logs out the current authenticated user.
 */
- (IBAction)logoutTapped:(id)sender
{
    [self.instagramEngine logout];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InstagramKit" message:@"You are now logged out." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
}


/**
 Method to present a new UINavigationController where the user has to authenticate against Instagram.
 */
- (void)login
{
    UINavigationController *loginNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
    [self.navigationController presentViewController:loginNavigationViewController animated:YES completion:nil];
}


#pragma mark - User Authenticated Notification -


/**
 Depending if the user has a valid session, we show the user's media or the Instagram's login page.
 */
- (void)userAuthenticationChanged:(NSNotification *)notification
{
    if ([self.instagramEngine isSessionValid])
    {
        [self loadMedia];
    }
    else
    {
        [self login];
    }
}


#pragma mark - UIStoryboardSegue -


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        IKMediaViewController *mediaViewController = (IKMediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        InstagramMedia *media = self.mediaArray[selectedIndexPath.item];
        [mediaViewController setMedia:media];
    }
}


#pragma mark - UICollectionViewDataSource Methods -


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    [cell setImageUrl:media.thumbnailURL];
    return cell;
}


- (void)updateCollectionViewLayout
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = floor((CGRectGetWidth(self.collectionView.bounds)-1) / kNumberOfCellsInARow);
    layout.itemSize = CGSizeMake(size, size);
}

@end
