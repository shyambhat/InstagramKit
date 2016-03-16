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

#import "IKSearchViewController.h"
#import "InstagramKit.h"
#import "IKSearchTagCell.h"
#import "IKSearchUserCell.h"
#import "IKSearchCollectionViewController.h"

#define kSignUser '@'
#define kSignHash '#'

@interface IKSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *elementArray;

@end


@implementation IKSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.elementArray = [[NSMutableArray alloc] init];
    
    [self.searchBar becomeFirstResponder];
}


#pragma mark - API Requests -


- (void)requestSearchTags:(NSString *)tag
{
    [[InstagramEngine sharedEngine] searchTagsWithName:tag
                                           withSuccess:^(NSArray *tags, InstagramPaginationInfo *paginationInfo) {
                                               [self.elementArray removeAllObjects];
                                               [self.elementArray addObjectsFromArray:tags];
                                               [self.tableView reloadData];
                                               
                                           } failure:^(NSError *error, NSInteger statusCode) {
                                               NSLog(@"Request Search Tags Failed");
                                           }];
}


- (void)requestSearchUsers:(NSString *)user
{
    [[InstagramEngine sharedEngine] searchUsersWithString:user
                                              withSuccess:^(NSArray *users, InstagramPaginationInfo *paginationInfo) {
                                                  [self.elementArray removeAllObjects];
                                                  [self.elementArray addObjectsFromArray:users];
                                                  [self.tableView reloadData];
                                                  
                                              } failure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Request Search Users Failed");
                                              }];
}


#pragma mark - UISearchBar Methods -


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text.length > 0) {
        char sign = [self.searchBar.text characterAtIndex:0];
        NSString *searchString = [self.searchBar.text substringFromIndex:1];
        
        // If the user doesn't specify if he wants to search a user or a hash, we put one them by default.
        if (sign != kSignUser && sign != kSignHash) {
            sign = kSignUser;
            searchString = self.searchBar.text;
            [self.searchBar setText:[NSString stringWithFormat:@"%c%@", sign, searchString]];
        }
        if (searchString.length > 0) {
            (sign == kSignUser) ? [self requestSearchUsers:searchString] : [self requestSearchTags:searchString];
        }
        
    } else {
        [self.elementArray removeAllObjects];
        [self.tableView reloadData];
    }
}


#pragma mark - UITableView Methods -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elementArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objClass = self.elementArray[indexPath.row];
    
    if ([objClass isKindOfClass:[InstagramUser class]]) {
        IKSearchUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"searchUserCell" forIndexPath:indexPath];
        InstagramUser *user = objClass;
        [userCell setUsername:user.username];
        [userCell setUserImageUrl:user.profilePictureURL];
        return userCell;
        
    } else if ([objClass isKindOfClass:[InstagramTag class]]) {
        IKSearchTagCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"searchTagCell" forIndexPath:indexPath];
        InstagramTag *tag = objClass;
        [tagCell setTagName:tag.name];
        [tagCell setMediaCount:tag.mediaCount];
        return tagCell;
        
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objClass = self.elementArray[indexPath.row];
    if ([objClass isKindOfClass:[InstagramUser class]]) {
        return 60;
    }
    return tableView.rowHeight;
}


#pragma mark - UIStoryboardSegue -


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.search.user.details"]) {
        IKSearchCollectionViewController *searchCollectionViewController = (IKSearchCollectionViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        InstagramUser *user = self.elementArray[selectedIndexPath.item];
        [searchCollectionViewController setInstagramUser:user];
    }
    if ([segue.identifier isEqualToString:@"segue.search.tag.details"]) {
        IKSearchCollectionViewController *searchCollectionViewController = (IKSearchCollectionViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        InstagramTag *tag = self.elementArray[selectedIndexPath.item];
        [searchCollectionViewController setInstagramTag:tag];
    }
}

@end
