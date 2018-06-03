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
#import "IKCell.h"
#import "InstagramMedia.h"
#import "IKMediaViewController.h"
#import "IKLoginViewController.h"

#define kNumberOfCellsInARow 3
#define kFetchItemsCount 15

@interface IKCollectionViewController ()

@property (nonatomic, strong)   NSMutableArray *mediaArray;
@property (nonatomic, strong)   InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak)     InstagramEngine *instagramEngine;

@end


@implementation IKCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    [self updateCollectionViewLayout];
    
    [self resetUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userAuthenticationChanged:)
                                                 name:InstagramKitUserAuthenticationChangedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.instagramEngine isSessionValid]) {
        [self loginTapped:nil];
    }
}


/**
 *  Depending on whether the Instagram session is authenticated,
 *  this method loads either the publicly accessible popular media
 *  or the authenticated user's feed.
 */
- (void)resetUI
{
    self.currentPaginationInfo = nil;
    
    BOOL isSessionValid = [self.instagramEngine isSessionValid];
    [self setTitle: (isSessionValid) ? @"Recent Media" : @"Login to begin"];
    [self.navigationItem.leftBarButtonItem setTitle: (isSessionValid) ? @"Log out" : @"Log in"];
    [self.navigationItem.rightBarButtonItem setEnabled: isSessionValid];
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
}


#pragma mark - API Requests -

/**
 Calls InstagramKit's helper method to fetch Media in the authenticated user's feed.
 @discussion The self.currentPaginationInfo object is updated on each successful call
 and it's updated nextMaxId is passed as a parameter to the next paginated request.
 */
- (void)requestRecentMedia
{
    [self.instagramEngine getSelfRecentMediaWithCount:kFetchItemsCount
                                                maxId:self.currentPaginationInfo.nextMaxId
                                              success:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                                  
                                                  self.currentPaginationInfo = paginationInfo;
                                                  
                                                  [self.mediaArray addObjectsFromArray:media];
                                                  [self.collectionView reloadData];
                                                  
                                                  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                                                  
                                              }
                                              failure:^(NSError * _Nonnull error, NSInteger serverStatusCode, NSDictionary * _Nonnull response) {
                                                  NSLog(@"Request Recent Media Failed");
                                                  NSLog(@" Response : \n %@",response);                                                  
                                              }];
}


/**
 Invoked when user taps the 'More' navigation item.
 @discussion The requestSelfFeed method is called with updated pagination parameters (nextMaxId).
 */
- (IBAction)moreTapped:(id)sender {
    [self requestRecentMedia];
}


/**
 Invoked when user taps the left navigation item.
 @discussion Either directs to the Login ViewController or logs out.
 */
- (IBAction)loginTapped:(id)sender
{
    if (![self.instagramEngine isSessionValid]) {
        UINavigationController *loginNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
        [self presentViewController:loginNavigationViewController animated:YES completion:nil];
    }
    else
    {
        [self.instagramEngine logout];
        [self showLogoutAlert];
    }
}

- (void)showLogoutAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"InstagramKit"
                                                                   message:@"You are now logged out."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - User Authenticated Notification -


- (void)userAuthenticationChanged:(NSNotification *)notification
{
    [self resetUI];
    
    [self requestRecentMedia];
    
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

-(IBAction)unwindSegue:(UIStoryboardSegue *)sender
{
    [sender.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource Methods -


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
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
