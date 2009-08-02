/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UITableViewCell-Compatibility.h"
#define DETAIL_TAG	901

@implementation UITableViewCell (Compatibility)
- (void) setLabelText: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	
	if ([self respondsToSelector:@selector(setText:)])
	{
		[self performSelector:@selector(setText:) withObject:outstring];
		return;
	}
	
	// Does  not respond to setText:
	if (![self respondsToSelector:@selector(textLabel)])
	{
		NSLog(@"Error: Cell does not respond to setText: nor textLabel");
		return;
	}
	
	UILabel *theTextLabel = [self performSelector:@selector(textLabel) withObject:nil];
	[theTextLabel setText:outstring];	
}


NSArray *allSubviews(UIView *aView)
{
	NSArray *results = [aView subviews];
	for (UIView *eachView in [aView subviews])
	{
		NSArray *riz = allSubviews(eachView);
		if (riz) results = [results arrayByAddingObjectsFromArray:riz];
	}
	return results;
}

- (UILabel *) getLabel
{
	// Not a very SDK-friendly way to access the label prior to 3.0
	if ([self respondsToSelector:@selector(textLabel)])
		return [self performSelector:@selector(textLabel)];
	else
	{
		NSArray *subviews = allSubviews(self);
		if ([subviews count] > 1) return [subviews objectAtIndex:1];
		return nil;
	}
}

- (void) setDetailText: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	
	// Does  not respond to setText:
	if (![self respondsToSelector:@selector(detailTextLabel)])
	{
		// Search for detail subview
		UILabel *detailLabel = (UILabel *) [self viewWithTag:DETAIL_TAG];
		[detailLabel setText:outstring];
		return;
	}
	
	UILabel *detailLabel = [self performSelector:@selector(detailTextLabel) withObject:nil];
	[detailLabel setText:outstring];		
}


- (UILabel *) getDetailLabel
{
	if ([self respondsToSelector:@selector(detailLabel)])
		return [self performSelector:@selector(detailLabel)];
	else
		return (UILabel *)[self viewWithTag:DETAIL_TAG];
}

- (void) rectifyDetailLabel
{
	// 3.0 and later
	if ([self respondsToSelector:@selector(detailTextLabel)]) return;

	// At this point, the label is defined but not yet moved into place and cell height is known.
	UILabel *detailLabel = [self getDetailLabel];
	if (!detailLabel) return;
	
	UILabel *textLabel = [self getLabel];
	float tHeight = textLabel ? textLabel.frame.size.height : 24.0f;
	detailLabel.center = CGPointMake(self.contentView.center.x + self.indentationWidth, (self.frame.size.height / 2.0f) + (tHeight / 2.0f) + (detailLabel.frame.size.height / 2.0f) + 2.0f);
}

+ (id) cellWithStyle: (uint) style reuseIdentifier: (NSString *) identifier
{
	UITableViewCell *cell = [UITableViewCell alloc];
	SEL initSelector = @selector(initWithStyle:reuseIdentifier:);
	
	if ([cell respondsToSelector:initSelector]) // 3.0 or later
	{
		NSMethodSignature *ms = [cell methodSignatureForSelector:initSelector];
		NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
		
		[inv setTarget:cell];
		[inv setSelector:initSelector];
		[inv setArgument:&style atIndex:2];
		[inv setArgument:&identifier atIndex:3];
		
		[inv invoke];
		
		return [cell autorelease];
	}
	
	// Earlier than 3.0
	CGRect frameRect = CGRectZero;
	
	initSelector = @selector(initWithFrame:reuseIdentifier:);
	NSMethodSignature *ms = [cell methodSignatureForSelector:initSelector];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
	
	[inv setTarget:cell];
	[inv setSelector:initSelector];
	[inv setArgument:&frameRect atIndex:2];
	[inv setArgument:&identifier atIndex:3];
	
	[inv invoke];
	
	// add subtitle
	if ((style != UITableViewCellStyleDefault) && (![cell viewWithTag:DETAIL_TAG]))
	{
		UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.contentView.bounds.size.width, 20.0f)];
		detailLabel.tag = DETAIL_TAG;
		detailLabel.font = [UIFont systemFontOfSize:14.0f];
		detailLabel.textColor = [UIColor lightGrayColor];
		detailLabel.backgroundColor = [UIColor clearColor];
		[cell addSubview:detailLabel];
	}
	
	return [cell autorelease];
}
@end
