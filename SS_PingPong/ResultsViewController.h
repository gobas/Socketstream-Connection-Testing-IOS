//
//  ResultsViewController.h
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UITableViewController {
  NSMutableArray *data;
}

@property(strong, nonatomic) NSMutableArray *data;

-(NSArray*)fetchAllEntities;

@end
