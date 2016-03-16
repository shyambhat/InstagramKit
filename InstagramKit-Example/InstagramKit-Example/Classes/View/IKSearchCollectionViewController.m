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

#import "IKSearchCollectionViewController.h"
#import "InstagramKit.h"
#import "IKCollectionCell.h"
#import "InstagramMedia.h"
#import "IKMediaViewController.h"

#define kNumberOfCellsInARow 4
#define kFetchItemsCount 20

@interface IKSearchCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) InstagramUser *user;
@property (nonatomic, strong) InstagramTag *tag;

@end


@implementation IKSearchCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaArray = [[NSMutableArray alloc] init];
    self.instagramEngine = [InstagramEngine sharedEngine];
    [self updateCollectionViewLayout];
    
    [self loadMedia];
}


- (void)loadMedia
{
    self.currentPaginationInfo = nil;
    
    [self.navigationItem.rightBarButtonItem setEnabled: NO];
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
    
    if (self.user)
    {
        [self setTitle:[NSString stringWithFormat:@"@%@", self.user.username]];
        [self requestUserMediaRecent];
    }
    else if (self.tag)
    {
        [self setTitle:[NSString stringWithFormat:@"#%@", self.tag.name]];
        [self requestTagMediaRecent];
    }
}


- (void)setInstagramUser:(InstagramUser *)user
{
    [self setUser:user];
}


- (void)setInstagramTag:(InstagramTag *)tag
{
    [self setTag:tag];
}


#pragma mark - API Requests -

/**
 @discussion You can get an error if the user's media you are trying to get, are from a private user account.
 */
- (void)requestUserMediaRecent
{
    [self.instagramEngine getMediaForUser:self.user.Id
                                    count:kFetchItemsCount
                                    maxId:self.currentPaginationInfo.nextMaxId
                              withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                  
                                  self.currentPaginationInfo = paginationInfo;
                                  [self.navigationItem.rightBarButtonItem setEnabled:(paginationInfo) ? YES : NO];
                                  
                                  if (media.count > 0) {
                                      [self.mediaArray addObjectsFromArray:media];
                                      [self.collectionView reloadData];
                                      
                                      [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                                  }
                                  
                              } failure:^(NSError *error, NSInteger statusCode) {
                                  NSLog(@"Request User Media Recent Failed");
                              }];
}


- (void)requestTagMediaRecent
{
    [self.instagramEngine getMediaWithTagName:self.tag.name
                                        count:kFetchItemsCount
                                        maxId:self.currentPaginationInfo.nextMaxId
                                  withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
                                      
                                      self.currentPaginationInfo = paginationInfo;
                                      [self.navigationItem.rightBarButtonItem setEnabled:(paginationInfo) ? YES : NO];
                                      
                                      if (media.count > 0) {
                                          [self.mediaArray addObjectsFromArray:media];
                                          [self.collectionView reloadData];
                                          
                                          [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                                      }
                                  } failure:^(NSError *error, NSInteger statusCode) {
                                      NSLog(@"Request Tag Media Recent Failed");
                                  }];
}


- (IBAction)moreTapped:(id)sender {
    if (self.user)
    {
        [self requestUserMediaRecent];
    }
    else if (self.tag)
    {
        [self requestTagMediaRecent];
    }
}


#pragma mark - UIStoryboardSegue -


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.search.detail"]) {
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
