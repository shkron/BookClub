//
//  AddFriendsViewController.m
//  BookClub
//
//  Created by Alex on 11/12/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AppDelegate.h"
#import "Friend.h"

@interface AddFriendsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *tableViewArray;
@property NSManagedObjectContext *moc;

@end

@implementation AddFriendsViewController


//MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.moc = [AppDelegate appDelegate].managedObjectContext;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self loadArrayFromCoreData];

    if (self.tableViewArray.count == 0)
    {
        [Friend retrieveFriendListWithCompletion:^(NSArray *array, NSError *error)
        {
            if (self.tableViewArray )
            {

                [self errorAlertWindow:error.localizedDescription];
            }
            else
            {
                self.tableViewArray = array;
                [self.tableView reloadData];
            }
        }];
    }
    else
    {
        [self loadArrayFromCoreData];
    }

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.moc save:nil];
}

//MARK: delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Friend *aFriend = self.tableViewArray[indexPath.row];
    cell.textLabel.text = aFriend.name;

    if (aFriend.isFriend)
    { //display checkmark
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    { // no checkmark
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }



    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *aFriend = self.tableViewArray[indexPath.row];
    if (aFriend.isFriend)
        {

//            cell.accessoryType = UITableViewCellAccessoryNone;
            aFriend.isFriend = NO;

        }
        else
        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            aFriend.isFriend = YES;

        }
//    [self.moc save:nil];
    NSArray *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}




//MARK: custom methods

-(void)loadArrayFromCoreData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];

    //sorting the table by the name
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    //array of sort descriptors in order
    request.sortDescriptors = @[sortByName];

    //mySQL format (for "filter")
//    request.predicate = [NSPredicate predicateWithFormat:@"age >= 150"];
    //executing fetch request for the entity "Trojan"
    self.tableViewArray = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}


-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
