//
//  StartViewController.m
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"

@implementation StartViewController

@synthesize timer;
@synthesize socket;
@synthesize connectionStatus;
@synthesize sendNumber;
@synthesize connectButton, disconnectButton;
@synthesize startSendButton, stopSendButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"Connection";
      self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
    
  self.connectButton.enabled = YES;
  self.disconnectButton.enabled = NO;
  self.startSendButton.enabled = NO;
  self.stopSendButton.enabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
  self.connectButton = nil;
  self.disconnectButton = nil;
  self.startSendButton = nil;
  self.stopSendButton = nil;
  self.connectionStatus = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - User action

-(IBAction)connect:(id)sender {
  self.socket = [[SocketIO alloc]initWithDelegate:self];
  [socket connectToHost:@"testing.shrnts.de" onPort:5555];
  
  sendNumber = [NSNumber numberWithInt:0];
}

-(IBAction)disconnect:(id)sender {
  [self.socket disconnect];
}

-(void)sendRequest {
  NSLog(@"sendRequest Methode aufgerufen");
  
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:@"app.sendTimeStamp" forKey:@"method"];
  [data setObject:[NSArray arrayWithObject:sendNumber] forKey:@"params"];
  
  NSLog(@"sending to server: %i", [sendNumber intValue]);
  
  [socket sendEvent:@"server" withData:data andAcknowledge:@selector(callback:)];
}

-(void)callback:(id)packet {
  NSLog(@"CALLBACK: %@", packet);
  NSLog(@"received: packet.result: %@", [packet objectForKey:@"result"]);
  
  sendNumber = [NSNumber numberWithInt:[[packet objectForKey:@"result"]intValue]];
}

-(void)startSendingInThread {
  @autoreleasepool {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    NSLog(@"startSending geklickt");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendRequest) userInfo:nil repeats:YES];
    
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
  }
}

-(IBAction)startSending:(id)sender {
  self.startSendButton.enabled = NO;
  self.stopSendButton.enabled = YES;
  
  [self performSelectorInBackground:@selector(startSendingInThread) withObject:nil];
}

-(IBAction)stopSending:(id)sender {
  self.startSendButton.enabled = YES;
  self.stopSendButton.enabled = NO;
  
  NSLog(@"stop sending geklickt");
  [self.timer invalidate];
}


#pragma mark - socketIO callbacks

- (void) socketIODidConnect:(SocketIO *)socket {
  NSLog(@"socket did connect");
  self.connectionStatus.text = @"connected";
  
  self.connectButton.enabled = NO;
  self.disconnectButton.enabled = YES;
  self.startSendButton.enabled = YES;
  self.stopSendButton.enabled = YES;
}

- (void) socketIODidDisconnect:(SocketIO *)socket {
  NSLog(@"socket did disconnect");
  self.connectionStatus.text = @"disconnected";
  
  self.connectButton.enabled = YES;
  self.disconnectButton.enabled = NO;
  self.startSendButton.enabled = NO;
  self.stopSendButton.enabled = NO;
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
  //NSLog(@"didReceiveEvent() >>> data: %@", packet.data);
 // NSLog(@"didReceiveEvent() >>> data: %@", packet.data);
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
  //NSLog(@"didSendMessage: %@", packet);
}



@end
