//
//    Copyright (c) 2013 Shyam Bhat
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
#import "UIImageView+AFNetworking.h"
#import "IKCell.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "IKLoginViewController.h"
#import "IKMediaViewController.h"

@interface IKCollectionViewController ()
{
    NSMutableArray *mediaArray;
    __weak IBOutlet UITextField *textField;
    BOOL isPopularFeed;
}
@end

@implementation IKCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mediaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMediaAnimated:NO];
}

- (IBAction)loadMedia
{
    [self loadMediaAnimated:YES];
}

- (void)loadMediaAnimated:(BOOL)animated
{
    InstagramEngine *sharedEngine = [InstagramEngine sharedEngine];
    
    if (sharedEngine.accessToken)
    {
        [[InstagramEngine sharedEngine] getSelfFeed:21 withSuccess:^(NSArray *media) {
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:media];

            (animated)?[self refreshCells]:[self reloadData];
            isPopularFeed = NO;
        } failure:^(NSError *error) {
            NSLog(@"Request Self Feed Failed");
        }];
    }
    else
    {
        [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media) {
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:media];
            (animated)?[self refreshCells]:[self reloadData];
            isPopularFeed = YES;
        } failure:^(NSError *error) {
           NSLog(@"Load Popular Media Failed");
       }];
    }
}

- (IBAction)searchMedia
{
    [textField resignFirstResponder];
    if ([textField.text length]) {
        [[InstagramEngine sharedEngine] getMediaWithTagName:textField.text withSuccess:^(NSArray *feed) {
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:feed];
            [self refreshCells];
            
        } failure:^(NSError *error) {
            NSLog(@"Search Media Failed");
        }];
    }
}

- (void)loadMediaForUser:(InstagramUser *)user
{
    [[InstagramEngine sharedEngine] getMediaForUser:user.Id count:20 withSuccess:^(NSArray *feed) {
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:feed];
        [self refreshCells];
        isPopularFeed = NO;
    } failure:^(NSError *error) {
        NSLog(@"Loading User media failed");
    }];
}

- (void)refreshCells
{
    [mediaArray enumerateObjectsUsingBlock:^(InstagramMedia *media, NSUInteger idx, BOOL *stop) {
        IKCell *cell = (IKCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        IKMediaViewController *mvc = (IKMediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        InstagramMedia *media = mediaArray[selectedIndexPath.item];
        mvc.media = media;
    }
    if ([segue.identifier isEqualToString:@"segue.login"]) {
        UINavigationController *loginNavigationVC = (UINavigationController *)segue.destinationViewController;
        IKLoginViewController *loginVc = loginNavigationVC.viewControllers[0];
        loginVc.collectionViewController = self;
    }
}

#pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (mediaArray.count >= indexPath.row+1) {
        InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }
    else
        [cell.imageView setImage:nil];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    InstagramMedia *media = mediaArray[indexPath.row];
    
    if (isPopularFeed) {
        [self loadMediaForUser:media.user];
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    if (tField.text.length) {
        [self searchMedia];
    }
    [tField resignFirstResponder];

    return YES;
}

@end
