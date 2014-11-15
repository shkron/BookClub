//
//  CommentsViewController.m
//  BookClub
//
//  Created by Alex on 11/14/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "CommentsViewController.h"
#import "Book.h"
#import "Comment.h"
#import "AppDelegate.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSArray *tableViewArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;

@end

@implementation CommentsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.title = self.aBook.title;

    [self loadComments];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.moc save:nil];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO: row count
    return self.tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

//    cell.textLabel.text = [self.tableViewArray[indexPath.row] text];

    Comment *c = self.tableViewArray[indexPath.row];
    cell.textLabel.text = c.text;
    return cell;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Comment";

    }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   Comment *aComment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class]) inManagedObjectContext:self.moc];
                                   UITextField *textField = alertcontroller.textFields.firstObject;

                                   aComment.text = textField.text;
                                   [self.aBook addCommentsObject:aComment];

                                   [self loadComments];


                               }];

    [alertcontroller addAction:okAction];

    [self presentViewController:alertcontroller animated:YES completion:^{
        nil;
    }];
}

-(void)loadComments
{
    self.tableViewArray = [NSArray arrayWithArray:[self.aBook.comments allObjects]];

    [self.tableView reloadData];
}


@end
