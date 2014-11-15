//
//  AddBookViewController.m
//  BookClub
//
//  Created by Alex on 11/14/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "AddBookViewController.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "Book.h"

@interface AddBookViewController ()
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property NSManagedObjectContext *moc;

@end

@implementation AddBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    self.title = @"Suggest a book";


    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.moc save:nil];

}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{

    if (![self.titleTextField.text isEqualToString:@""])
    {
        Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.moc];
        newBook.title = self.titleTextField.text;
        newBook.author = self.authorTextField.text;

        [self.aFriend addBooksObject:newBook];

        self.titleTextField.text = @"";
        self.authorTextField.text = @"";

        self.title = @"Suggest another book";
    }
    else
    {
        self.title = @"Need a book title! DUH";
    }

}


@end
