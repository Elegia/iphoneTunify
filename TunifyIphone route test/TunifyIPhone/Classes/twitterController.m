//
//  twitterController.m
//  TunifyIPhone
//
//  Created by thesis on 22/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "twitterController.h"


@implementation twitterController

@synthesize pub;
@synthesize strAchievementName;
@synthesize strAchievementDesc;
@synthesize strAchievementLocation;
@synthesize charactersLeft;
@synthesize charactersLeftLabel;
@synthesize twitterMessageView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) 
	{ 
		[alertView release];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)showSuccess {
	
	if ([[self.pub name] length] > 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",@"title") 
															message:NSLocalizedString(@"Your visit has been published.",  
																					  @"message") 
															delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
															otherButtonTitles:nil]; 
		
		[alertView show]; 
		
	} else if ([strAchievementName length] > 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",@"title") 
															message:NSLocalizedString(@"Your achievement has been published.",  
																					  @"message") 
															delegate:self 
															cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
															otherButtonTitles:nil]; 
		
		[alertView show]; 
	}
	

}

- (void)showError {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while connecting to Twitter.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	
	[alertView show];
}

- (void)postToTwitter {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	NSString *twitterUsername = [userDefaults stringForKey:@"twitter_username"];
	NSString *twitterPassword = [userDefaults stringForKey:@"twitter_password"];
	
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@@twitter.com/statuses/update.xml", twitterUsername, twitterPassword]] 
														cachePolicy:NSURLRequestUseProtocolCachePolicy 
														timeoutInterval:60.0]; 
	
	
	
	[theRequest setHTTPMethod:@"POST"]; 
	[theRequest setHTTPBody:[[NSString stringWithFormat:@"status=%@", self.twitterMessageView.text] dataUsingEncoding:NSASCIIStringEncoding]]; 
	
	NSURLResponse* response; 
	NSError* error; 
	NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error]; 
	
	NSLog(@"%@", [[[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding] autorelease]);
	NSLog(@"error: %@", error);
	
	[twitterUsername release];
	[twitterPassword release];
	
	if(error == nil) {
		[self showSuccess];
	} else {
		[self showError];
	}
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  

	if ([text isEqualToString:@"\n"]) {  
		[textView resignFirstResponder];  
		[self postToTwitter];
		return NO;
	}
	
	if([text length] == 0) {
		if(self.charactersLeft < 140) {
			self.charactersLeft = self.charactersLeft + 1;
			self.charactersLeftLabel.text = [NSString stringWithFormat:@"%d", self.charactersLeft];
		}
	} else {
		if(self.charactersLeft <= 0) {
			return NO;
		} else {
			self.charactersLeft = self.charactersLeft - 1;
			self.charactersLeftLabel.text = [NSString stringWithFormat:@"%d", self.charactersLeft];
		}
	}
	
	return YES;
} 
 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string && [string length] && [textField.text length] >= 140) {
        return NO;
    }
	
    self.charactersLeft = self.charactersLeft - 1;
	self.charactersLeftLabel.text = [NSString stringWithFormat:@"%d", self.charactersLeft];
	
    return YES;
}


-(void) btnCancel_clicked:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = [self.pub name];
	
	// Create the left bar button item
	UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] init];
	cancelBarButtonItem.title = @"Cancel";
	cancelBarButtonItem.target = self;
	cancelBarButtonItem.action = @selector(btnCancel_clicked:);
	self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
	[cancelBarButtonItem release];
	
	if ([[self.pub name] length] > 0) {
		[self.twitterMessageView setText:[[@"Going to '" stringByAppendingString:[self.pub name]] stringByAppendingString:@"'."]];
	} else if ([strAchievementName length] > 0) {
		[self.twitterMessageView setText:[[[[[@"Achievement '" stringByAppendingString:self.strAchievementName] 
											stringByAppendingString:@"' reached @ "]
											stringByAppendingString:self.strAchievementLocation] stringByAppendingString:@": "]
											stringByAppendingString:self.strAchievementDesc]];
	}
	
	[self.twitterMessageView becomeFirstResponder];
	self.charactersLeft = 140 - [self.twitterMessageView.text length];
	self.charactersLeftLabel.text = [NSString stringWithFormat:@"%d", self.charactersLeft];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[pub release];
	[strAchievementName release];
	[strAchievementDesc release];
	[strAchievementLocation release];
	[charactersLeftLabel release];
	[twitterMessageView release];
    [super dealloc];
}


@end
