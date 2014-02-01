//
//  IKMediaViewController.m
//  InstagramKitDemo
//
//  Created by Shyam Bhat on 01/02/14.
//  Copyright (c) 2014 Shyam Bhat. All rights reserved.
//

#import "IKMediaViewController.h"
#import "InstagramMedia.h"
#import "IKMediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramUser.h"

@interface IKMediaViewController ()

@end

@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = 320;
            break;
            
        default:
            retVal = 50;
            break;
    }
    return retVal;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        IKMediaCell *cell = (IKMediaCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
        [cell.mediaImageView setImageWithURL:self.media.thumbnailURL];
        [cell.mediaImageView setImageWithURL:self.media.standardResolutionImageURL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Likes",self.media.likesCount];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Comments",self.media.commentCount];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
