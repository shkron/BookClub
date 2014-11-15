//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Alex on 11/14/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "AddBookViewController.h"
#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "Book.h"

@interface FriendDetailViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property NSArray *booksTableViewArray;
@property (strong, nonatomic) IBOutlet UIImageView *friendImageVIew;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;

@end

@implementation FriendDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.title = self.aFriend.name;

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.booksTableViewArray = [NSArray arrayWithArray:[self.aFriend.books allObjects]];
    [self.tableView reloadData];

    UIImage *image = [[UIImage alloc] initWithData:self.aFriend.photo];
    self.friendImageVIew.image = image;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.moc save:nil];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksTableViewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Book *aBook = self.booksTableViewArray[indexPath.row];
    cell.textLabel.text = aBook.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by: %@", aBook.author];

    return cell;
}

- (IBAction)onImageAddButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //allows to modify the picture properties
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //which source to enter
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
    NSData *profileImageData = UIImagePNGRepresentation(pickerImage);
    self.aFriend.photo = profileImageData;

    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"addBookSegue"])
    {
        AddBookViewController *addBookVC = segue.destinationViewController;
        addBookVC.aFriend = self.aFriend;
    }
    else if ([segue.identifier isEqualToString:@"commentsSegue"])
    {
        CommentsViewController *commetsVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        commetsVC.aBook = self.booksTableViewArray[selectedIndexPath.row];
    }

}

@end
