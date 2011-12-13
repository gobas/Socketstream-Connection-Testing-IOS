//
//  StartViewController.h
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface StartViewController : UIViewController <SocketIODelegate> {
  NSTimer *timer;
  SocketIO *socket;
  
  IBOutlet UILabel *connectionStatus;
  
  NSNumber *sendNumber;
  
  IBOutlet UIButton *connectButton;
  IBOutlet UIButton *disconnectButton;
  IBOutlet UIButton *startSendButton;
  IBOutlet UIButton *stopSendButton;
}

@property(strong, nonatomic) UIButton *connectButton;
@property(strong, nonatomic) UIButton *disconnectButton;
@property(strong, nonatomic) UIButton *startSendButton;
@property(strong, nonatomic) UIButton *stopSendButton;

@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) SocketIO *socket;
@property(strong, nonatomic) UILabel *connectionStatus;
@property(strong, nonatomic) NSNumber *sendNumber;


-(IBAction)connect:(id)sender;
-(IBAction)disconnect:(id)sender;

-(IBAction)startSending:(id)sender;
-(IBAction)stopSending:(id)sender;

@end
