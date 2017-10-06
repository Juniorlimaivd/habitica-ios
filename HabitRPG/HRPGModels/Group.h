//
//  Group.h
//  HabitRPG
//
//  Created by Phillip Thelen on 16/04/14.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class ChatMessage, QuestCollect, User;

@interface Group : NSManagedObject

@property(nonatomic, retain) NSString *hdescription;
@property(nonatomic, retain) NSString *id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *privacy;
@property(nonatomic, retain) NSNumber *questActive;
@property(nonatomic, retain) NSNumber *questHP;
@property(nonatomic, retain) NSString *questLeader;
@property(nonatomic, retain) NSNumber *questRage;
@property(nonatomic, retain) NSString *questKey;
@property(nonatomic, retain) NSNumber *worldDmgTavern;
@property(nonatomic, retain) NSNumber *worldDmgStable;
@property(nonatomic, retain) NSNumber *worldDmgMarket;
@property(nonatomic, retain) NSNumber *unreadMessages;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSOrderedSet *chatmessages;
@property(nonatomic, retain) User *leader;
@property(nonatomic, retain) NSSet *member;
@property(nonatomic, retain) NSSet *questParticipants;
@property(nonatomic, retain) NSSet *collectStatus;
@property(nonatomic, retain) NSNumber *isMember;
@property(nonatomic, retain) NSNumber *memberCount;
@property(nonatomic, retain) NSNumber *balance;
@property(nonatomic, retain) NSString *summary;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)insertObject:(ChatMessage *)value inChatmessagesAtIndex:(NSUInteger)idx;

- (void)removeObjectFromChatmessagesAtIndex:(NSUInteger)idx;

- (void)insertChatmessages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;

- (void)removeChatmessagesAtIndexes:(NSIndexSet *)indexes;

- (void)replaceObjectInChatmessagesAtIndex:(NSUInteger)idx withObject:(ChatMessage *)value;

- (void)replaceChatmessagesAtIndexes:(NSIndexSet *)indexes withChatmessages:(NSArray *)values;

- (void)addChatmessagesObject:(ChatMessage *)value;

- (void)addChatmessagesObjectAtFirstPosition:(ChatMessage *)value;

- (void)removeChatmessagesObject:(ChatMessage *)value;

- (void)addChatmessages:(NSOrderedSet *)values;

- (void)removeChatmessages:(NSOrderedSet *)values;

- (void)addMemberObject:(User *)value;

- (void)removeMemberObject:(User *)value;

- (void)addMember:(NSSet *)values;

- (void)removeMember:(NSSet *)values;

- (void)addCollectStatusObject:(QuestCollect *)value;

- (void)removeCollectStatusObject:(QuestCollect *)value;

- (void)addCollectStatus:(NSSet *)values;

- (void)removeCollectStatus:(NSSet *)values;

@end
