//
//  StartViewController.m
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "Request.h"
#import "AppDelegate.h"

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

/**
 Erstellt die WebSocket-Verbindung zum Server.
 */
-(IBAction)connect:(id)sender {
  self.socket = [[SocketIO alloc]initWithDelegate:self];
  //[socket connectToHost:@"testing.shrnts.de" onPort:5555];
  [socket connectToHost:@"localhost" onPort:3000];
  
}

/**
 Trennt die WebSocket-Verbindung.
 */
-(IBAction)disconnect:(id)sender {
  //[self.timer invalidate];
  [timer performSelectorInBackground:@selector(invalidate) withObject:nil];
  [self.socket disconnect];
}

/**
 Startet den Timer zum Senden von Daten an den Server.
 Die Methode wird ueber den Button auf der GUI aufgerufen.
 */
-(IBAction)startSending:(id)sender {
  self.startSendButton.enabled = NO;
  self.stopSendButton.enabled = YES;
  
  //starte den Timer in einem Thread
  [self performSelectorInBackground:@selector(startSendingInThread) withObject:nil];
}

/**
 Stoppt den Timer, der Requests an den Server sendet.
 */
-(IBAction)stopSending:(id)sender {
  self.startSendButton.enabled = YES;
  self.stopSendButton.enabled = NO;
  
  //[self.timer invalidate];
  [timer performSelectorInBackground:@selector(invalidate) withObject:nil];
}

/**
 Erstellt den Timer und setzt die Ausfuehrung in einen extra RunLoop.
 */
-(void)startSendingInThread {
  @autoreleasepool {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendRequest) userInfo:nil repeats:YES];
    
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
  }
}

/**
 Methode die periodische durch den Timer aufgerufen wird.
 */
-(void)sendRequest {  
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:@"app.sendTimeStamp" forKey:@"method"];
  [data setObject:[NSArray arrayWithObject:sendNumber] forKey:@"params"];
  
  NSLog(@"sending to server: %i", [sendNumber intValue]);
  
  [socket sendEvent:@"server" withData:data andAcknowledge:@selector(callback:)];
}

/**
 Callback-Methode der send-Methode
 */
-(void)callback:(id)packet {
  NSLog(@"CALLBACK: %@", packet);
  NSLog(@"received: packet.result: %@", [packet objectForKey:@"result"]);
  
  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
  
  Request *request = (Request*)[NSEntityDescription insertNewObjectForEntityForName:@"Request" inManagedObjectContext: [appDelegate managedObjectContext] ];
  request.send = sendNumber; 
  
  if ([packet objectForKey:@"result"] != nil) {
    request.result = [NSNumber numberWithInt:[[packet objectForKey:@"result"]intValue]];
  }
  [appDelegate saveContext];
  
  //aktualisiere die zu sendende Nummer, mit dem response vom Server
  self.sendNumber = [NSNumber numberWithInt:[[packet objectForKey:@"result"]intValue]];
  
}


#pragma mark - socketIO callbacks

- (void) socketIODidConnect:(SocketIO *)socket {
  NSLog(@"socket did connect");
  self.connectionStatus.text = @"connected";
  
  self.sendNumber = [NSNumber numberWithInt:0];
  
  self.connectButton.enabled = NO;
  self.disconnectButton.enabled = YES;
  self.startSendButton.enabled = YES;
  self.stopSendButton.enabled = YES;
}

- (void) socketIODidDisconnect:(SocketIO *)socket {
  NSLog(@"socket did disconnect");
  self.connectionStatus.text = @"disconnected";
  
  [timer performSelectorInBackground:@selector(invalidate) withObject:nil];
  
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
