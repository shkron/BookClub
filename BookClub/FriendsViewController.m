//
//  ViewController.m
//  BookClub
//
//  Created by Alex on 11/12/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "FriendsViewController.h"
#import "AddFriendsViewController.h"
#import "FriendDetailViewController.h"
#import "Friend.h"
#import "AppDelegate.h"


@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSArray *tableViewArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *searchBar;
@property NSManagedObjectContext *moc;

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadArrayWithFetchRequestFromCoreData:@" "];
}


//MARK: delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.tableViewArray[indexPath.row] name];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
//    searchText

    if (searchText.length == 0)
    {
        [self loadArrayWithFetchRequestFromCoreData:@" "];
    }
    else
    {
        [self loadArrayWithFetchRequestFromCoreData:searchText];
    }
    
    [self.tableView reloadData];
}


//MARK: custom methods

-(void)loadArrayWithFetchRequestFromCoreData:(NSString *)searchText
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];

    //sorting the table by the name
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    //array of sort descriptors in order
    request.sortDescriptors = @[sortByName];

//    mySQL format (for "filter")
    request.predicate = [NSPredicate predicateWithFormat:@"(isFriend == YES) AND (name CONTAINS [cd] %@)", searchText];
//    executing fetch request for the entity "Friend"
    self.tableViewArray = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}





//MARK: segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        FriendDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        detailVC.aFriend = self.tableViewArray[selectedIndexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"addFriendSegue"])
    {

    }
//    AddFriendsViewController *addFriendsVC = segue.destinationViewController;
//    addFriendsVC.selectedFriendsArray = self.tableViewArray;
}

@end
