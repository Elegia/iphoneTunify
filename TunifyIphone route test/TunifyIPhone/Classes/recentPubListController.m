//
//  recentPubListController.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "recentPubListController.h"
#import "mapViewController.h"
#import "pubCell.h"
#import "CellButton.h"
#import "genreViewController.h"

@implementation recentPubListController

@synthesize genre;
@synthesize dataSource;
@synthesize tableView;
@synthesize rowPlaying;
@synthesize userLocation;
@synthesize buttonPlaying;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (IBAction)btnFilter_clicked:(id)sender {
	NSLog(@"Filter clicked");
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles:@"By genre",@"By song",@"By rating", @"By visitors", @"By distance", nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
    [popupQuery showInView:self.tabBarController.view];
    [popupQuery release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		// Sort by genre
		genreViewController *gvc = [[genreViewController alloc] initWithNibName:@"genreView" bundle:[NSBundle mainBundle]];
		gvc.sourceView = self;
		gvc.sourceId = 3;
		[self.navigationController pushViewController:gvc animated:YES];
		[gvc release];
		gvc = nil;
		
    } else if (buttonIndex == 1) {
		// Sort by song similarity
	} else if (buttonIndex == 2) {
		// Sort by rating
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		
		for(Pub *pub in dataSource) {
			// Initial entry
			if ([sortedArray count] == 0) {
				[sortedArray addObject:pub];
			} else {
				// Further entries
				if ([[pub rating] intValue] <= [[[sortedArray lastObject] rating] intValue]) {
					[sortedArray addObject:pub];
				} else if ([[pub rating] intValue] >= [[[sortedArray objectAtIndex:0] rating] intValue]) {
					[sortedArray insertObject:pub atIndex:0];
				} else {
					for(int i=0; i<[sortedArray count]; i++) {
						if ([[pub rating] intValue] == [[[sortedArray objectAtIndex:i] rating] intValue]) {
							[sortedArray insertObject:pub atIndex:i];
							break;
						} else if ([[pub rating] intValue] < [[[sortedArray objectAtIndex:i] rating] intValue] && [[pub rating] intValue] > [[[sortedArray objectAtIndex:i+1] rating] intValue]) {
							[sortedArray insertObject:pub atIndex:i+1];
							break;
						}
					} // end for loop
				}				
			}
		} // end for loop
		
		[dataSource removeAllObjects];
		dataSource = sortedArray;
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:dataSource];
		[tableView reloadData];
		
	} else if (buttonIndex == 3) {
		// Sort by visitors
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		
		for(Pub *pub in dataSource) {
			NSLog(@"Pub: %@", [pub name]);
			NSLog(@"Visitors: %@", [pub visitors]);
			// Initial entry
			if ([sortedArray count] == 0) {
				[sortedArray addObject:pub];
			} else {
				// Further entries
				if ([[pub visitors] intValue] <= [[[sortedArray lastObject] visitors] intValue]) {
					[sortedArray addObject:pub];
				} else if ([[pub visitors] intValue] >= [[[sortedArray objectAtIndex:0] visitors] intValue]) {
					[sortedArray insertObject:pub atIndex:0];
				} else {
					for(int i=0; i<[sortedArray count]; i++) {
						if ([[pub visitors] intValue] == [[[sortedArray objectAtIndex:i] visitors] intValue]) {
							[sortedArray insertObject:pub atIndex:i];
							break;
						} else if ([[pub visitors] intValue] < [[[sortedArray objectAtIndex:i] visitors] intValue] && [[pub visitors] intValue] > [[[sortedArray objectAtIndex:i+1] visitors] intValue]) {
							[sortedArray insertObject:pub atIndex:i+1];
							break;
						}
					} // end for loop
				}				
			}
		} // end for loop
		
		[dataSource removeAllObjects];
		dataSource = sortedArray;
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:dataSource];
		[tableView reloadData];
		// Sort by visitors
	} else if (buttonIndex == 4) {
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		for(Pub *pub in dataSource) {
			NSLog(@"Pub: %@", [pub name]);
			
			CLLocationDegrees longitude= [[pub longitude] doubleValue];
			CLLocationDegrees latitude = [[pub latitude] doubleValue];
			CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
			CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
			[pubLocation release];
			
			NSLog(@"Distance: %f", distance);
			
			// Initial entry
			if ([sortedArray count] == 0) {
				[sortedArray addObject:pub];
			} else {
				// Further entries
				CLLocationDegrees longitude= [[[sortedArray lastObject] longitude] doubleValue];
				CLLocationDegrees latitude = [[[sortedArray lastObject] latitude] doubleValue];
				CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
				CLLocationDistance lastPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
				[pubLocation release];
				
				longitude= [[[sortedArray objectAtIndex:0] longitude] doubleValue];
				latitude = [[[sortedArray objectAtIndex:0] latitude] doubleValue];
				pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
				CLLocationDistance firstPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
				[pubLocation release];
				
				if (distance >= lastPubDistance) {
					[sortedArray addObject:pub];
				} else if (distance <= firstPubDistance) {
					[sortedArray insertObject:pub atIndex:0];
				} else {
					for(int i=0; i<[sortedArray count]; i++) {
						
						CLLocationDegrees longitude= [[[sortedArray objectAtIndex:i] longitude] doubleValue];
						CLLocationDegrees latitude = [[[sortedArray objectAtIndex:i] latitude] doubleValue];
						CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
						CLLocationDistance otherPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
						[pubLocation release];
						
						if (distance == otherPubDistance) {
							[sortedArray insertObject:pub atIndex:i];
							break;
						} else { 
							CLLocationDegrees longitude= [[[sortedArray objectAtIndex:i+1] longitude] doubleValue];
							CLLocationDegrees latitude = [[[sortedArray objectAtIndex:i+1] latitude] doubleValue];
							CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
							CLLocationDistance nextPubDistance = [ct fetchDistance:self.userLocation locationB:pubLocation]/1000;
							[pubLocation release];
							
							if (distance > otherPubDistance && distance < nextPubDistance) {
								[sortedArray insertObject:pub atIndex:i+1];
								break;
							}
						}
					} // end for loop
				}				
			}
		} // end for loop
		
		[dataSource removeAllObjects];
		dataSource = sortedArray;
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:dataSource];
		[tableView reloadData];
	}
}

- (void) playMusic:(id)sender {
	CellButton *button = (CellButton *)sender;
	self.buttonPlaying = button;
	
	if (self.rowPlaying == -1) {
		// Nothing is playing yet
		self.rowPlaying = button.row;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		
		//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		//audioPlayer.delegate = self;
		//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
		
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer playTest:@"song1"];
	} else {
		if (self.rowPlaying == button.row) {
			// Our current cell is playing
			self.rowPlaying = -1;
			[button setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			//[audioPlayer stop];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer stopTest];
		} else {
			NSLog(@"a");
			NSLog(@"row playing: %d", self.rowPlaying);
			//NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:self.rowPlaying];
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			pubCell *c = (pubCell *)cell;
			NSLog(@"b");
			[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			// Now update our current cell
			self.rowPlaying = button.row;
			[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
			
			//AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			//audioPlayer.delegate = self;
			//[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			[audioPlayer stopTest];
			[audioPlayer playTest:@"song1"];
			
			[indexPath release];
		}
	}
	
	/*
	NSLog(@"Playing the sound of the pub");
	
	CellButton *button = (CellButton *)sender;
	self.buttonPlaying = button;
	
	if (self.rowPlayingIndexPath == nil ) {
		// Nothing is playing yet
		self.rowPlayingIndexPath = button.indexPath;
		[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
		
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		audioPlayer.delegate = self;
		[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
	} else {
		if (self.rowPlayingIndexPath.row == button.indexPath.row) {
			// Our current cell is playing
			self.rowPlayingIndexPath = nil;
			[button setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			audioPlayer.delegate = nil;
			[audioPlayer stop];
		} else {
			// Another cell is playing. We need to stop it and play our current one.
			
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.rowPlayingIndexPath];
			pubCell *c = (pubCell *)cell;
			[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
			
			// Now update our current cell
			self.rowPlayingIndexPath = button.indexPath;
			[button setImage:[UIImage imageNamed:@"pauze2.png"] forState:UIControlStateNormal];
			
			AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
			audioPlayer.delegate = self;
			[audioPlayer play:@"http://localhost:1935/live/mp3:NoRain.mp3/playlist.m3u8"];
			
		}
	}
	 */
	
}


- (void) showMusic:(id)sender {
	CellButton *button = (CellButton *)sender;
	Pub *thePub = (Pub*)[self.dataSource objectAtIndex:button.row];
	musicViewController *controller = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	controller.pub = thePub;
	controller.source = 1;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
	
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)theplayer successfully:(BOOL)flag { 
	NSLog(@"Song played");
	[theplayer release]; 
} 


#pragma mark -
#pragma mark AudioPlayer delegate
- (void)audioPlayerError:(AudioPlayer *)sender {
	
	[self.buttonPlaying setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"Could not contact the Tunify server. Audio playback will not work.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	
	[alertView show]; 
}


- (void) pubCell_clicked:(id)sender pub:(Pub*)pub {
	mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
	controller.pub = pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}
	
- (void)viewDidLoad {
    [super viewDidLoad];

	searchBar.showsCancelButton = YES;
	
	self.navigationItem.title = @"Recently visited";
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	self.navigationItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];

	// This is required to prevent the bottom part of the table from hiding behind the tab bar.
	[self.tableView setFrame:CGRectMake(0,0,320,400)];
	
}

- (void)viewDidAppear:(BOOL)animated {

	if(rowPlaying == -1) {
		AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
		[audioPlayer stopTest];
	} 
	
	
	CoordinatesTool *ct = [CoordinatesTool sharedInstance];
	[ct reInit];
	ct.delegate = self;
	[ct fetchUserLocation];
	
	[tableView reloadData];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// Stop the music and reset all play buttons to the play icon
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer stopTest];
	if (rowPlaying > -1) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowPlaying inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		pubCell *c = (pubCell *)cell;
		[c.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	}
	self.rowPlaying = -1;
}


- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	
	// Create some test data for the table
	dataSource = [[NSMutableArray alloc] init];
	
	// Get the recently visited pubs
	RecentlyVisited *rv = [RecentlyVisited sharedInstance];
	NSLog(@"Fetching recent pubs");
	dataSource = [rv getRecentPubs];
	NSLog(@"End fetching recent pubs");
	
	tableData = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	[tableData addObjectsFromArray:dataSource];
	
	[tableView reloadData];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)userLocationError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while fetching your position.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	[alertView show]; 
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
	
	pubCell *cell = (pubCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[pubCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Pub *pub = [tableData objectAtIndex:indexPath.row];
	cell.nameLabel.text = [pub name];
	
	if (self.userLocation != nil) {
		CLLocationDegrees longitude= [[pub longitude] doubleValue];
		CLLocationDegrees latitude = [[pub latitude] doubleValue];
		CLLocation* pubLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		
		CoordinatesTool *ct = [CoordinatesTool sharedInstance];
		CLLocationDistance distance = [ct fetchDistance:self.userLocation locationB:pubLocation];
		[pubLocation release];
		NSString *strDistance = [NSString stringWithFormat:@"%f", distance/1000];
		NSRange commaRange = [strDistance rangeOfString:@"."];
		strDistance = [strDistance substringToIndex:commaRange.location + 2];
		cell.distanceLabel.text = [NSString stringWithFormat:@"%@ km", strDistance];
	} else {
		cell.distanceLabel.text = @"Distance unknown";
	}

	// Set stars rating
	[cell.stars setRating:[[pub rating] intValue]];
	// Set visitors amount
	cell.visitorsLabel.text = pub.visitors;

	[cell.playButton setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
	[cell.playButton addTarget:self	action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.playButton.row = indexPath.row;
	
	[cell.infoButton setImage:[UIImage imageNamed:@"infoButton.png"] forState:UIControlStateNormal];
	[cell.infoButton addTarget:self action:@selector(showMusic:) forControlEvents:UIControlEventTouchUpInside];
	cell.infoButton.row = indexPath.row;
	
    return cell;	
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Pub *pub = (Pub *)[dataSource objectAtIndex:indexPath.row];
	[self pubCell_clicked:theTableView pub:pub];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
	
	// only show the status bar’s cancel button while in edit mode
	theSearchBar.showsCancelButton = YES;
	theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
	theSearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[tableData removeAllObjects]; // remove all data that belongs to previous search
	if([searchText isEqualToString:@""] || searchText == nil) {
		[tableData addObjectsFromArray:dataSource];
		[tableView reloadData];
		return;
	}
	
	NSInteger counter = 0;
	for(Pub *pub in dataSource) 
	{
		NSString *name = [pub name];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(r.location != NSNotFound)
		{
			[tableData addObject:pub];
		}
		counter++;
		[pool release];
		
	}
	
	[tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:dataSource];
	@try{
		[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[theSearchBar resignFirstResponder];
	theSearchBar.text = @"";
	[tableView reloadData];
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	[theSearchBar resignFirstResponder];
}


- (void)dealloc {
	[genre release];
	[dataSource release];
	[buttonPlaying release];
	[tableView release];
	[userLocation release];
    [super dealloc];
}


@end

