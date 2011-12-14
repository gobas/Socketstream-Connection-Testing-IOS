//
//  Request.h
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Request : NSManagedObject

@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSNumber * send;
@property (nonatomic, retain) NSDate * createdAt;

@end
