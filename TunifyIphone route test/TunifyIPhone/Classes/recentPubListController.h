//
//  recentPubListController.h
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h> 
#import "CoordinatesTool.h"
#import "RecentlyVisited.h"
#import "AudioPlayer.h"

@class CellButton;
@interface recentPubListController : UITableViewController <UIActionSheetDelegate, AudioPlayerDelegate, CoordinatesToolDelegate> {
	
	NSMutableArray *dataSource;		// stores all data
	NSMutableArray *tableData;		// stores data displayed in the table
	NSMutableArray *searchedData;	// stores search results
	
	IBOutlet UITableView *tableView;
	IBOutlet UISearchBar *searchBar;
	
	NSString *genre;
	
	//NSIndexPath *rowPlayingIndexPath;
	NSInteger rowPlaying;
	CellButton *buttonPlaying;
	
	CLLocation *userLocation;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSString *genre;
@property (assign) NSInteger rowPlaying;
@property (nonatomic, retain) CellButton *buttonPlaying;
@property (nonatomic, retain) CLLocation *userLocation;

- (void) pubCell_clicked:(id)sender pub:(Pub*)pub;
- (void) btnFilter_clicked:(id)sender;
- (void) playMusic:(id)sender;

@end
