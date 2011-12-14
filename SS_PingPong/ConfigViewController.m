//
//  ConfigViewController.m
//  SS_PingPong
//
//  Created by Sebastian Kruschwitz on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"

@implementation ConfigViewController

@synthesize urlTextField, portTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"Config";
      self.tabBarItem.image = [UIImage imageNamed:@"third"];
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
  
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  if ([defs valueForKey:@"url"] != nil) {
    urlTextField.text = [defs valueForKey:@"url"];
  }
  if ([defs valueForKey:@"port"] != nil) {
    portTextField.text = [defs valueForKey:@"port"];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)save:(id)sender {
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  [defs setValue:urlTextField.text forKey:@"url"];
  [defs setValue:portTextField.text forKey:@"port"];
  [defs synchronize];
  
  [urlTextField resignFirstResponder];
  [portTextField resignFirstResponder];
}

@end
