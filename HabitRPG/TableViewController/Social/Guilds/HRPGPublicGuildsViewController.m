//
//  HRPGPublicGuildsViewController.m
//  Habitica
//
//  Created by Phillip Thelen on 05/02/16.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

#import "HRPGPublicGuildsViewController.h"
#import "HRPGPublicGuildTableViewCell.h"
#import "HRPGGroupTableViewController.h"
#import "HRPGCoreDataDataSource.h"
#import "NSString+Emoji.h"
#import "UIColor+Habitica.h"

@interface HRPGPublicGuildsViewController ()
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) NSString *searchValue;
@property HRPGCoreDataDataSource *dataSource;
@end

@implementation HRPGPublicGuildsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor purple400];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    self.searchBar =
        [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;

    [self refresh];
}

- (void)setupTableView {
    
    __weak HRPGPublicGuildsViewController *weakSelf = self;
    TableViewCellConfigureBlock configureCell = ^(HRPGPublicGuildTableViewCell *cell, Group *guild, NSIndexPath *indexPath) {
        [weakSelf configureCell:cell withGuild:guild];
    };
    FetchRequestConfigureBlock configureFetchRequest = ^(NSFetchRequest *fetchRequest) {
        NSPredicate *predicate;
        if (weakSelf.searchValue) {
            predicate = [NSPredicate
                    predicateWithFormat:
                    @"type == 'guild' && ((name CONTAINS[cd] %@) || (hdescription CONTAINS[cd] %@))",
                    weakSelf.searchValue, weakSelf.searchValue];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"type == 'guild'"];
        }
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"memberCount" ascending:NO];
        NSArray *sortDescriptors = @[ sortDescriptor ];
        [fetchRequest setSortDescriptors:sortDescriptors];
    };
    self.dataSource= [[HRPGCoreDataDataSource alloc] initWithManagedObjectContext:self.managedObjectContext
                                                                       entityName:@"Group"
                                                                   cellIdentifier:@"Cell"
                                                               configureCellBlock:configureCell
                                                                fetchRequestBlock:configureFetchRequest
                                                                    asDelegateFor:self.tableView];
}

- (void)refresh {
    __weak HRPGPublicGuildsViewController *weakSelf = self;
    [[HRPGManager sharedManager] fetchGroups:@"publicGuilds"
        onSuccess:^() {
            [weakSelf.refreshControl endRefreshing];
        }
        onError:^() {
            [weakSelf.refreshControl endRefreshing];
        }];
}

- (void)configureCell:(HRPGPublicGuildTableViewCell *)cell withGuild:(Group *)guild {
    [cell configureForGuild:guild];
    cell.joinAction = ^() {
        [[HRPGManager sharedManager] joinGroup:guild.id withType:guild.type onSuccess:nil onError:nil];
    };
    cell.leaveAction = ^() {
        [[HRPGManager sharedManager] leaveGroup:guild withType:guild.type onSuccess:nil onError:nil];
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGuildSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Group *guild = [self.dataSource itemAtIndexPath:indexPath];
        HRPGGroupTableViewController *guildViewController =
                segue.destinationViewController;
        guildViewController.groupID = guild.id;
    }
}

#pragma mark - Search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchValue = searchText;

    if ([self.searchValue isEqualToString:@""]) {
        self.searchValue = nil;
    }

    [self.dataSource reconfigureFetchRequest];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];

    self.searchValue = nil;

    [self.dataSource reconfigureFetchRequest];

    [searchBar resignFirstResponder];
}

@end
