/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UITableViewCell-Compatibility.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

@interface TestBedViewController : UITableViewController
{
	uint style;
}
@end

@implementation TestBedViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell rectifyDetailLabel];
}

// Return a cell for the ith row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Use re-usable cells to minimize the memory load
	// UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basic cell"];
	
	UITableViewCell *cell = nil; // force new cells always to demonstrate each height
	if (!cell) cell = [UITableViewCell cellWithStyle:style reuseIdentifier:@"basic cell"];
	
	[cell setLabelText:@"Cell number %d", indexPath.row];
	[cell setDetailText:@"Cell number %d", indexPath.row];
	
	return cell;
}

- (void) changeHeight: (UISegmentedControl *) seg
{
	self.tableView.rowHeight = 80.0f + 20.0f * [seg selectedSegmentIndex];
	[self.tableView reloadData];
}

- (void) normal
{
	style = UITableViewCellStyleDefault;
	[self.tableView reloadData];
}

- (void) subtitle
{
	style = UITableViewCellStyleSubtitle;
	[self.tableView reloadData];
}

- (void) loadView
{
	[super loadView];
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Normal", @selector(normal));
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Subtitle", @selector(subtitle));

	UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[@"80 100 120" componentsSeparatedByString:@" "]];
	seg.segmentedControlStyle = UISegmentedControlStyleBar;
	seg.selectedSegmentIndex = 0;
	[seg addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = seg;
	
	self.tableView.rowHeight = 80.0f;
	
	style = UITableViewCellStyleDefault;
	
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedViewController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}
