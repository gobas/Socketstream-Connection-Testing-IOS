//
//  ConfigViewController.h
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController {
  IBOutlet UITextField *urlTextField;
  IBOutlet UITextField *portTextField;
}

@property(strong, nonatomic) UITextField *urlTextField;
@property(strong, nonatomic) UITextField *portTextField;

-(IBAction)save:(id)sender;

@end
