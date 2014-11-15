//
//  Friend.h
//  BookClub
//
//  Created by Alex on 11/12/14.
//  Copyright (c) 2014 Alexey Emelyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^friendBlock)(NSArray* array, NSError *error);

@class Book;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *books;
@property BOOL isFriend;
@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;
+ (void)retrieveFriendListWithCompletion:(friendBlock)complete;



@end
