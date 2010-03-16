//
//  pubList3DController.m
//  TunifyIPhone
//
//  Created by thesis on 18/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pubList3DController.h"
#import "pubListController.h"
#import "genreViewController.h"

@implementation pubList3DController

@synthesize searchBar;
@synthesize genre;
@synthesize overlayView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//overlayView.center = CGPointMake(160, 250);
	self.overlayView.opaque = YES;
	//overlayView.alpha = OVERLAY_ALPHA;
	
	//UIImageView *binocs = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binocs.png"]] autorelease];
	//binocs.tag = BINOCS_TAG;
	//[self.overlayView addSubview:binocs];
	/*
	UILabel* overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 40)];
	overlayLabel.text = @"De Werf";
	overlayLabel.textAlignment = UITextAlignmentLeft;
	overlayLabel.adjustsFontSizeToFitWidth = NO;
	overlayLabel.textColor = [UIColor whiteColor];
	overlayLabel.backgroundColor = [UIColor darkGrayColor];
	overlayLabel.shadowOffset = CGSizeMake(0, -1);  
	overlayLabel.shadowColor = [UIColor blackColor]; 
	
	[overlayView addSubview:overlayLabel];
	*/
	self.view = self.overlayView;

}



- (IBAction)btnFilter_clicked:(id)sender {
	NSLog(@"Filter clicked");
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles:@"By genre",@"By song",@"By rating", @"By visitors",nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
    [popupQuery showInView:self.tabBarController.view];
    [popupQuery release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		// Sort by genre
		genreViewController *gvc = [[genreViewController alloc] initWithNibName:@"genreView" bundle:[NSBundle mainBundle]];
		gvc.sourceView = self;
		gvc.sourceId = 2;
		[self.navigationController pushViewController:gvc animated:YES];
		[gvc release];
		gvc = nil;
		
    } else if (buttonIndex == 1) {
		// Sort by song similarity
    } else if (buttonIndex == 2) {
		// Sort by rating
	} else if (buttonIndex == 3) {
		// Sort by visitors
	}
}

- (IBAction)btnList_clicked:(id)sender {
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	searchBar.showsCancelButton = YES;
	
	
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480);     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }

	
	self.navigationItem.title = @"Pubs";
	
	// Create the left bar button item
	UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] init];
	filterBarButtonItem.title = @"Filter";
	filterBarButtonItem.target = self;
	filterBarButtonItem.action = @selector(btnFilter_clicked:);
	self.navigationItem.leftBarButtonItem = filterBarButtonItem;
	[filterBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] init];
	listBarButtonItem.title = @"List";
	listBarButtonItem.target = self;
	listBarButtonItem.action = @selector(btnList_clicked:);
	self.navigationItem.rightBarButtonItem = listBarButtonItem;
	[listBarButtonItem release];
	
	// Create some test overlays
	UIView* pub1view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 90)];
	pub1view.center = CGPointMake(160, 250);
	pub1view.backgroundColor = [UIColor lightGrayColor];
	
	//UIImageView *binocs = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binocs.png"]] autorelease];
	//binocs.tag = BINOCS_TAG;
	//[self.overlayView addSubview:binocs];
	
	UILabel* pub1name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 20)];
	pub1name.text = @"De Werf";
	pub1name.textAlignment = UITextAlignmentLeft;
	pub1name.font = [UIFont systemFontOfSize:14];
	pub1name.adjustsFontSizeToFitWidth = NO;
	pub1name.textColor = [UIColor blackColor];
	pub1name.backgroundColor = [UIColor lightGrayColor];

	
	UILabel* pub1address = [[UILabel alloc] initWithFrame:CGRectMake(5, 21, 190, 20)];
	pub1address.text = @"Tiensestraat 45 3000 Leuven";
	pub1address.textAlignment = UITextAlignmentLeft;
	pub1address.font = [UIFont systemFontOfSize:12];
	pub1address.adjustsFontSizeToFitWidth = NO;
	pub1address.textColor = [UIColor blackColor];
	pub1address.backgroundColor = [UIColor lightGrayColor];
	
	UILabel* pub1visitors = [[UILabel alloc] initWithFrame:CGRectMake(5, 37, 190, 20)];
	pub1visitors.text = @"Visitors: 24";
	pub1visitors.textAlignment = UITextAlignmentLeft;
	pub1visitors.font = [UIFont systemFontOfSize:12];
	pub1visitors.adjustsFontSizeToFitWidth = NO;
	pub1visitors.textColor = [UIColor blackColor];
	pub1visitors.backgroundColor = [UIColor lightGrayColor];
	
	UIImageView *star1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60, 13, 13)];
	star1.image = [UIImage imageNamed:@"star_small.png"];
	[pub1view addSubview:star1];
	UIImageView *star2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 13, 13)];
	star2.image = [UIImage imageNamed:@"star_small.png"];
	[pub1view addSubview:star2];
	UIImageView *star3 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 60, 13, 13)];
	star3.image = [UIImage imageNamed:@"star_small.png"];
	[pub1view addSubview:star3];
	UIImageView *star4 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 60, 13, 13)];
	star4.image = [UIImage imageNamed:@"star_light_small.png"];
	[pub1view addSubview:star4];
	UIImageView *star5 = [[UIImageView alloc] initWithFrame:CGRectMake(65, 60, 13, 13)];
	star5.image = [UIImage imageNamed:@"star_light_small.png"];
	[pub1view addSubview:star5];
	
	[pub1view addSubview:pub1visitors];
	[pub1view addSubview:pub1address];
	[pub1view addSubview:pub1name];
	 
	[self.overlayView addSubview:pub1view];
	

	UIImagePickerController *picker;
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		picker = [[UIImagePickerController alloc] init];
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		picker.delegate = self;
		picker.allowsImageEditing = NO;
	}
	else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		
		picker = [[UIImagePickerController alloc] init];
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		picker.delegate = self;
		picker.allowsImageEditing = NO;
		[self presentModalViewController:picker animated:YES];
	}
	else {
		picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need an iPhone with a camera to use this application."
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
		[alertView release];
	}

	/*
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.allowsImageEditing = NO;
	[self presentModalViewController:picker animated:YES];
	 */
	/*
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];     
	ipc.delegate = self;
	ipc.allowsImageEditing = NO;
	[self presentModalViewController:ipc animated:YES];
	*/
	
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	NSLog(@"Did finish picking image");
	[picker dismissModalViewControllerAnimated:YES];
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


#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searching = YES;
	
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	/*
	[tableData removeAllObjects]; // remove all data that belongs to previous search
	if([searchText isEqualToString:@""]) {
		searching = NO;
		searchText==nil;
	} else { 
		searching = YES;
		[tableView reloadData];
		return;
	}
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(r.length > 0) {
			//[tableData addObject:name];
		}
		counter++;
		[pool release];
	}
	*/
	//[tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	//[tableData removeAllObjects];
	//[tableData addObjectsFromArray:dataSource];
	@try{
		//[tableView reloadData];
	}
	@catch(NSException *e){
	}
	[searchBar resignFirstResponder];
	searchBar.text = @"";
}

//called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	searching = NO;
	[searchBar resignFirstResponder];
}


- (void)dealloc {
	[genre release];
	[searchBar release];
	[overlayView release];
	[super dealloc];
}


@end
