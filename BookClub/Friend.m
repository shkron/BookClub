//
//  Friend.m
//  BookClub
//
//  Created by Alex on 11/12/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import "Friend.h"
#import "Book.h"
#import "AppDelegate.h"

#define kURL @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"


@implementation Friend

@dynamic name;
@dynamic photo;
@dynamic books;
@dynamic isFriend;

+ (void)retrieveFriendListWithCompletion:(friendBlock)complete
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = delegate.managedObjectContext;

    NSURL *url = [NSURL URLWithString:kURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSError *JSONError = nil;

        if (!connectionError)
        {
            NSArray *namesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];

            if (!JSONError)
            {
                NSMutableArray *friendsArray;
                friendsArray = [NSMutableArray array];
                for (NSString *name in namesArray)
                {
                    Friend *aFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
                    aFriend.name = name;
                    [friendsArray addObject:aFriend];
                }
                [moc save:nil];
                complete (friendsArray,connectionError);
            }
            else
            {
                complete (nil,JSONError);
            }
        }
        else
        {
            complete (nil,connectionError);
        }
    }];
}


@end
