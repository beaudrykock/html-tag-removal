//
//  Snippet.m
//  smartParseTest
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "Snippet.h"


@implementation Snippet

@synthesize text, tags;

-(void)addTag:(Tag*)newTag
{
	[tags addObject: newTag];
}

-(void)setup
{
	tags = [NSMutableArray arrayWithCapacity:5];
    allowFormatting = YES;
}

-(BOOL)hasBoldTag
{
    BOOL found = NO;
    int counter = 0;
    while (!found && counter < [tags count])
    {
        if ([[tags objectAtIndex:counter] type] == kBoldType) found = YES;
            counter++;
    }
    
    return found;
}

-(BOOL)hasItalicTag
{
    BOOL found = NO;
    int counter = 0;
    while (!found && counter < [tags count])
    {
        if ([[tags objectAtIndex:counter] type] == kItalicType) found = YES;
            counter++;
    }
    
    return found;
}

-(BOOL)isDud
{
    BOOL dud = NO;
    if ([text length]<=0)
    {
        dud = YES;
    }
    else if ([text rangeOfCharacterFromSet: [NSCharacterSet alphanumericCharacterSet]].location == NSNotFound)
    {
        // just contains whitespace - not necessarily a dud, but you don't want to apply any formatting to this one
        allowFormatting = NO;
    }
    return dud;
}

// Handles removal of any troublesome lingering unwanted tags, etc which you couldn't address
// in main parsing code
-(void)cleanThyself
{
    NSMutableString *mutableText = [NSMutableString stringWithString:text];
    NSString *tagRemnant1 = @"&gt;";
    
    NSScanner *scanner = [NSScanner scannerWithString: mutableText];
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:tagRemnant1 intoString:nil];
        
        if ([scanner scanLocation]<[mutableText length]-1)
        {
            [mutableText replaceCharactersInRange: NSMakeRange([scanner scanLocation], [tagRemnant1 length]) withString: @""];
            scanner = [NSScanner scannerWithString:mutableText];
        }
    }
    
    text = [NSString stringWithString:mutableText];
    
}

-(BOOL)formattingAllowed
{
    return allowFormatting;
}

-(void)print
{
    NSLog(@"\n\nPrinting contents of snippet");
    NSLog(@"Full text: %@", text);
    NSLog(@"Tags...");
    for (Tag *tag in tags)
    {
        [tag print];
    }
}

-(void)dealloc
{
	[super dealloc];
	[text release];
	[tags release];
}

@end
