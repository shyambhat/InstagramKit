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

@interface IKCollectionViewController ()
{
    NSMutableArray *mediaArray;
    __weak IBOutlet UITextField *textField;
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
    [self requestMedia];
}

- (void)requestMedia
{
    [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media) {
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Request Media Failed");
    }];
}

- (IBAction)searchMedia
{
    [textField resignFirstResponder];
    if ([textField.text length]) {
        [[InstagramEngine sharedEngine] getMediaWithTag:textField.text withSuccess:^(NSArray *feed) {
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:feed];
            [self refreshCells];
            
        } failure:^(NSError *error) {
            NSLog(@"Search Media Failed");
        }];
    }
}

- (IBAction)reloadMedia
{
    [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media) {
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
    }
    failure:^(NSError *error) {
       
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
    InstagramMedia *media = mediaArray[indexPath.row];
    [media.user loadCountsWithSuccess:^{
        NSLog(@"Courtesy: %@. %d media posts, follows %d users and is followed by %d users",media.user.username, media.user.mediaCount, media.user.followsCount, media.user.followedByCount);
        
        [[InstagramEngine sharedEngine] getMediaForUser:media.user.Id count:20 withSuccess:^(NSArray *feed) {
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:feed];
            [self refreshCells];
        } failure:^(NSError *error) {
            NSLog(@"Loading User media failed");
        }];

    } failure:^{
        NSLog(@"Loading User details failed");
    }];
}

-(IBAction)didSelectLogin:(id)sender
{
    [[InstagramEngine sharedEngine] loginWithBlock:^(NSError *error) {
    
        if (error)
        {

            NSLog(@"Instagram login error %@ code %d", [error localizedDescription], [error code]);

            NSString *title = @"Failed :(";
            NSString *message = [NSString stringWithFormat:@"Failed to login: %@ (code %d)", [error localizedDescription], [error code]];

            [[[UIAlertView alloc]
             initWithTitle:title
             message:message
             delegate:nil
             cancelButtonTitle:@"Whomp whomp"
             otherButtonTitles: nil] show];

            return;
        }

        NSLog(@"Successfully logged in with Instagram.");

        [[InstagramEngine sharedEngine] getSelfUserDetailWithSuccess:^(InstagramUser *userDetail) {

            NSLog(@"Instagram login error %@ code %d", [error localizedDescription], [error code]);
            
            NSString *title = @"It worked :)";
            NSString *message = [NSString stringWithFormat:@"Welcome %@", userDetail.username];

            [[[UIAlertView alloc]
              initWithTitle:title
              message:message
              delegate:nil
              cancelButtonTitle:@"Huzzah!"
              otherButtonTitles: nil] show];

        } failure:^(NSError *error) {

            NSLog(@"Instagram login error %@ code %d", [error localizedDescription], [error code]);
            
            NSString *title = @"Failed :(";
            NSString *message = [NSString stringWithFormat:@"Failed to get profile: %@ (code %d)", [error localizedDescription], [error code]];

            [[[UIAlertView alloc]
              initWithTitle:title
              message:message
              delegate:nil
              cancelButtonTitle:@"Whomp whomp"
              otherButtonTitles: nil] show];

            return;
            
        }];

    }];
}

@end
