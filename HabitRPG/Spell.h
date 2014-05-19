//
//  Spell.h
//  RabbitRPG
//
//  Created by Phillip Thelen on 19/05/14.
//  Copyright (c) 2014 Phillip Thelen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Spell : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * klass;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * mana;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * text;

@end
