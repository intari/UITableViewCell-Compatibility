/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

// Constants not defined prior to 3.x
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000
typedef enum {
	UITableViewCellStyleDefault,
	UITableViewCellStyleValue1,
	UITableViewCellStyleValue2,
	UITableViewCellStyleSubtitle
} UITableViewCellStyle;
#endif

@interface UITableViewCell (Compatibility)
- (void) setLabelText: (NSString *) formatstring, ...;
- (void) setDetailText: (NSString *) formatstring, ...;
- (UILabel *) getLabel; // not 2.x friendly, iffy workaround
- (UILabel *) getDetailLabel;
+ (id) cellWithStyle: (uint) style reuseIdentifier: (NSString *) identifier;

// Must be called during tableView:willDisplayCell:forRowAtIndexPath:
- (void) rectifyDetailLabel;
@end
