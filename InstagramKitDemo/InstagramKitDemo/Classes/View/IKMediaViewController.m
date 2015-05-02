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

#import "IKMediaViewController.h"
#import "IKMediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramKit.h"

@interface IKMediaViewController ()
{
    BOOL liked;
}
@end

@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
    [self testLoadUserDetails];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[InstagramEngine sharedEngine] accessToken])?4:3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = self.tableView.bounds.size.width;
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
        
        switch (indexPath.row) {
            case 1:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                {
                    if (liked) {
                        cell.textLabel.text = @"Unlike";
                    }
                    else
                    {
                        cell.textLabel.text = @"Like";
                    }
                    
                }
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Likes",(long)self.media.likesCount];
            }
                break;
                
            case 2:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                    cell.textLabel.text = @"Test Comment";
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Comments",(long)self.media.commentCount];
            }
                break;
                
            default:
            {
                cell.textLabel.text = @"Test";
            }
                break;
                
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        if ([[InstagramEngine sharedEngine] accessToken])
        {
            if (!liked) {
                [self testLike];
            }
            else
            {
                [self testUnlike];
            }
        }
        else
        {
            [self testGetLikes];
        }
    }
    else if (indexPath.row == 2) {
        
        if ([[InstagramEngine sharedEngine] accessToken])
        {
            [self testAddComment];
        }
        else
        {
            [self testComments];
        }

    }
    else if (indexPath.row == 3)
    {
        [self testCustom1];
    }
    else
    {
        [self testCustom2];
    }
}

#pragma mark - Tests -

- (void)testGetMedia
{
    [[InstagramEngine sharedEngine] getMedia:self.media.Id withSuccess:^(InstagramMedia *media) {
        NSLog(@"Load Media Successful");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Loading Media Failed");
    }];
}

- (void)testLoadUserDetails
{
    [self.media.user loadUserDetailsWithSuccess:^{
        NSLog(@"Courtesy: %@. %ld media posts, follows %ld users and is followed by %ld users",self.media.user.username, (long)self.media.user.mediaCount, (long)self.media.user.followsCount, (long)self.media.user.followedByCount);
    } failure:^{
        NSLog(@"Loading User details failed");
    }];
    
}

- (void)testComments
{
    [[InstagramEngine sharedEngine] getCommentsOnMedia:self.media.Id withSuccess:^(NSArray *comments) {
        for (InstagramComment *comment in comments) {
            NSLog(@"@%@: %@",comment.user.username, comment.text);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Could not load comments");
    }];
}

- (void)testGetLikes
{
    [[InstagramEngine sharedEngine] getLikesOnMedia:self.media.Id withSuccess:^(NSArray *likedUsers, InstagramPaginationInfo *paginationInfo) {
        for (InstagramUser *user in likedUsers) {
            NSLog(@"Like : @%@",user.username);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Could not load likes");
    }];
}

- (void)testLike
{
    [[InstagramEngine sharedEngine] likeMedia:self.media.Id withSuccess:^{
        liked = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        NSLog(@"Like Success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Like Failure");
    }];
}

- (void)testUnlike
{
    [[InstagramEngine sharedEngine] unlikeMedia:self.media.Id withSuccess:^{
        liked = NO;
        NSLog(@"Unlike Success");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Unlike Failure");
    }];
}

- (void)testAddComment
{
    [[InstagramEngine sharedEngine] createComment:@"Test" onMedia:self.media.Id withSuccess:^{
        NSLog(@"Create Comment Success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Create Comment Failure");
    }];
}

- (void)testRemoveComment
{
    
}

- (void)testCustom1
{
    [self testFollowUser];
}

- (void)testCustom2
{
    [self testUnfollowUser];
}

- (void)testRelationshipStatusOfUser:(NSString *)userId
{
    [[InstagramEngine sharedEngine] getRelationshipStatusOfUser:userId withSuccess:^(NSDictionary *responseDictionary) {
        NSLog(@"responseDictionary %@",responseDictionary);
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"fail %@",error);
    }];
}
- (void)testGetUsersFollowedByUser:(NSString *)userId
{
    [[InstagramEngine sharedEngine] getUsersFollowedByUser:userId withSuccess:^(NSArray *objects, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"Get Follows Success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Get Follows Failure");
 
    }];
}

- (void)testGetFollowersOfUser:(NSString *)userId
{
    [[InstagramEngine sharedEngine] getFollowersOfUser:userId withSuccess:^(NSArray *objects, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"Get Followers Success");
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Get Followers Failure");
        
    }];
}

- (void)getSelfFollowRequests
{
    [[InstagramEngine sharedEngine] getFollowRequestsWithSuccess:^(NSArray *objects, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"Get Requests Success");
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Get Requests Failure");
        
    }];

}

- (void)testFollowUser
{
    [[InstagramEngine sharedEngine] followUser:self.media.user.Id withSuccess:^(NSDictionary *response)
    {
        NSLog(@"follow success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"failed to follow");
    }];
}



- (void)testUnfollowUser
{
    [[InstagramEngine sharedEngine] unfollowUser:self.media.user.Id withSuccess:^(NSDictionary *response)
    {
        NSLog(@"unfollow success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"failed to unfollow");
    }];
}


- (void)testBlockUser
{
    [[InstagramEngine sharedEngine] blockUser:self.media.user.Id withSuccess:^(NSDictionary *response)
    {
        NSLog(@"block success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"failed to block");
    }];
}


- (void)testUnblockUser
{
    [[InstagramEngine sharedEngine] unblockUser:self.media.user.Id withSuccess:^(NSDictionary *response)
    {
        NSLog(@"unblock success");
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"failed to unblock");
    }];
}




@end
