//
//  Request.m
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Request.h"


@implementation Request

@dynamic result;
@dynamic send;
@dynamic createdAt;

-(void)awakeFromInsert {
  [super awakeFromInsert];
  [self setValue:[NSDate date] forKey:@"createdAt"];
}

@end
