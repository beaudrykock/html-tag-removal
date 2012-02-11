//
//  SmartParse.m
//  html-tag-removal
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "SmartParse.h"

@implementation SmartParse

@synthesize boldRanges;
@synthesize italicRanges;
@synthesize fulltext;
@synthesize tagStringsAndTypes;
@synthesize snippets;
@synthesize tags;

/*
 * 1. Extracts converted HTML paragraph tags and replaces them with NSParagraphSeparatorCharacter
 * 2. Removes converted HTML tags for <strong>, <em>, <i> and <div> and creates NSRange objects for formatting
 *    each section of string appropriately; stores these objects in the boldFonts and italicFonts arrays
 * 3. Extracts converted HTML line break tags and replaces them with NSLineSeparatorCharacter
 * 
 */

-(void)parse
{
	
#ifdef DEBUG_SP
		NSLog(@"contents before parsing = %@",fulltext);
#endif
		
        tagCounter = 0;
        
        //if([[self title] isEqualToString:@"Muddy Waters: Silt and the Slow Demise of Glen Canyon Dam"])
        //{
        //   NSLog(@"stop");
        // }
        
        // setup dictionaries
        // content removal tags should just be ignored (not added to tag list)
        NSDictionary *contentRemovalTags = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"",@"object",
                                            @"", @"script",
                                            @"", @" align=\"center\"",
                                            @"", @" style=\"text-align: center; \"",
                                            @"", @"div", 
                                            @"", @"a", 
                                            @"", @"style",
                                            @"* * *", @"le=\"text-align: center;\"&gt;* * *", nil];
        
        NSEnumerator *contentRemovalEnumerator = [contentRemovalTags keyEnumerator];
        NSString *key;
        
        
        // nonbracketed tags should be swept for and removed prior to parsing
        NSDictionary *nonbracketedTags = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"", @"&amp;nbsp;", 
                                          @"", @"----",
                                          @"&", @"&amp;amp;", nil];
        NSEnumerator *nonBracketedTagsEnumerator = [nonbracketedTags keyEnumerator];
        
        tagStringsAndTypes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: 0],@"p",
                              [NSNumber numberWithInt: 1],@"b",
                              [NSNumber numberWithInt: 1],@"strong",
                              [NSNumber numberWithInt: 2],@"i",
                              [NSNumber numberWithInt: 2],@"em",
                              [NSNumber numberWithInt: 3],@"br /",nil];
        
        NSString *lineBreakReplacement = [NSString stringWithFormat:@"%C", NSNewlineCharacter];
        NSString *paragraphTagReplacement = [NSString stringWithFormat: @"%C%C",NSLineSeparatorCharacter, NSLineSeparatorCharacter]; //]NSTabCharacter]; //@"%C%@", NSNewlineCharacter,@"    "]; 
        NSDictionary *singletonTags = [NSDictionary dictionaryWithObjectsAndKeys:
                                       lineBreakReplacement,@"&lt;br /&gt;",
                                       paragraphTagReplacement,@"&lt;p&gt;",
                                       @"",@"&lt;/p&gt;",
                                       nil];
        
        NSString *newLineCharAsStr = [NSString stringWithFormat:@"%C", NSNewlineCharacter];
        NSString *carriageReturnCharAsStr = [NSString stringWithFormat:@"%C", NSCarriageReturnCharacter];
        NSString *lineSeparatorCharAsStr = [NSString stringWithFormat:@"%C", NSLineSeparatorCharacter];
        NSString *paragraphSeparatorCharAsStr = [NSString stringWithFormat:@"%C", NSParagraphSeparatorCharacter];
        NSDictionary *controlAndFormattingMarks = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"", newLineCharAsStr,
                                                   @"", carriageReturnCharAsStr,
                                                   @"", lineSeparatorCharAsStr,
                                                   @"", paragraphSeparatorCharAsStr,nil];
        
        // initialize ranges
        boldRanges = [NSMutableArray arrayWithCapacity:10];
        italicRanges = [NSMutableArray arrayWithCapacity:10];
        
        snippets = [NSMutableArray arrayWithCapacity:100];
        tags = [NSMutableArray arrayWithCapacity:100];
        
        // assign text from file
        NSMutableString *stringToParse = [[NSMutableString alloc] init]; 
        [stringToParse setString: fulltext];
        NSScanner *mainScanner;
        NSString *lessThanBracket = @"&lt;";
        NSString *greaterThanBracket = @"&gt;";
        NSString *scanContents = @"";
        BOOL found = NO;
        BOOL subFound = NO;
        int index = 0;
        NSString *tagToMatch;
        int startLocation = 0;
        
        // sweep for nonbracketed tags first
        mainScanner = [NSScanner scannerWithString:stringToParse];
        NSString *objectForKey;
        while ((key = (NSString*)[nonBracketedTagsEnumerator nextObject]))
        {	
            [mainScanner setScanLocation:0];
            while (![mainScanner isAtEnd]) {
                [mainScanner scanUpToString:key intoString:NULL];
                if (![mainScanner isAtEnd])
                {	
                    startLocation = [mainScanner scanLocation];
                    objectForKey = (NSString*)[nonbracketedTags valueForKey:key];
                    [stringToParse replaceCharactersInRange:NSMakeRange([mainScanner scanLocation], [key length]) withString: objectForKey];
                    mainScanner = [NSScanner scannerWithString:stringToParse];
                    [mainScanner setScanLocation:startLocation+[objectForKey length]];
                    
                }
#ifdef DEBUG_SP 
                NSLog(@"After removing unbracketed object, stringToParse is... %@", stringToParse);
#endif
            }
        }
        
        NSEnumerator *controlAndFormattingMarksEnumerator = [controlAndFormattingMarks keyEnumerator];
        mainScanner = [NSScanner scannerWithString:stringToParse];
        
        [mainScanner setCharactersToBeSkipped:nil];
        while ((key = (NSString*)[controlAndFormattingMarksEnumerator nextObject]))
        {	
            [mainScanner setScanLocation:0];
            while (![mainScanner isAtEnd]) {
                [mainScanner scanUpToString:key intoString:nil];
                if (![mainScanner isAtEnd])
                {	
                    startLocation = [mainScanner scanLocation];
                    [stringToParse replaceCharactersInRange:NSMakeRange([mainScanner scanLocation], [key length]) withString:[controlAndFormattingMarks valueForKey:key]];
                    mainScanner = [NSScanner scannerWithString:stringToParse];
                    [mainScanner setCharactersToBeSkipped:nil];
                    [mainScanner setScanLocation:startLocation+[[controlAndFormattingMarks valueForKey:key]length]];
                    
                }
            }
        }
        
        // now sweep for bracketed singletons that can be easily replaced or removed
        NSEnumerator *singletonTagsEnumerator = [singletonTags keyEnumerator];
        mainScanner = [NSScanner scannerWithString:stringToParse];
        [mainScanner setCharactersToBeSkipped:nil];
        while ((key = (NSString*)[singletonTagsEnumerator nextObject]))
        {	
            [mainScanner setScanLocation:0];
            while (![mainScanner isAtEnd]) {
                [mainScanner scanUpToString:key intoString:NULL];
                if (![mainScanner isAtEnd])
                {	
                    startLocation = [mainScanner scanLocation];
                    [stringToParse replaceCharactersInRange:NSMakeRange([mainScanner scanLocation], [key length]) withString:[singletonTags valueForKey:key]];
                    mainScanner = [NSScanner scannerWithString:stringToParse];
                    [mainScanner setCharactersToBeSkipped:nil];
                    [mainScanner setScanLocation:startLocation+[[singletonTags valueForKey:key] length]];
#ifdef DEBUG_SP 
                    NSLog(@"After removing bracketed singleton object, stringToParse is... %@", stringToParse);
#endif
                }
            }
        }
#ifdef DEBUG_SP 
        NSLog(@"stringToParse before main parsing = %@", stringToParse);
#endif
        // re-initialize 
        mainScanner = [NSScanner scannerWithString:stringToParse];
        [mainScanner setCharactersToBeSkipped:nil];
        
        while (![mainScanner isAtEnd])
        {
            // reset variables
            scanContents = @"";
            contentRemovalEnumerator = nil;
            contentRemovalEnumerator = [contentRemovalTags keyEnumerator];
            
            // scan to '<'
            [mainScanner scanUpToString:lessThanBracket intoString:&scanContents];
            startLocation = [mainScanner scanLocation];
            
            // if scan contents, create snippet
            if ([scanContents length] > 0)
            {
                
                Snippet *newSnippet = [[Snippet alloc] init];
                [newSnippet setup];
                [newSnippet setText: scanContents];
                
                // if there are any open tags, attach any that are open
                if ([self openTagsExist])
                {
                    for (Tag *tag in tags)
                    {
                        if ([tag isOpen])
                        {
                            [newSnippet addTag:tag];
#ifdef DEBUG_SP 
                            NSLog(@"\n\nDEBUG: attaching open tag to new snippet");
#endif
                            // if tag is a paragraph tag, close the tag, since the paragraph break should only be inserted
                            // at the beginning of the snippet with which the tag is attached; i.e. a single paragraph tag
                            // can only be associated with one snippet
                            if ([tag isParagraph])
                            {
                                [tag setIsOpen:NO];
                            }
                        }
                    }
                }
#ifdef DEBUG_SP 
                NSLog(@"\n\nDEBUG: creating snippet with full text: %@", [newSnippet text]);
#endif
                // store newSnippet
                [snippets addObject: newSnippet];
                
            }
            
            // initialize tag scanning
            // scan to '>'
            [mainScanner scanUpToString:greaterThanBracket intoString:&scanContents];
            
            // first check for content removal tags
            found = NO;
            while ((key = (NSString*)[contentRemovalEnumerator nextObject]) && !found)
            {	
                
                if ([scanContents rangeOfString: key].location != NSNotFound)
                {
                    found = YES;
                    tagToMatch = key;
                }
                
            }
            
            if (found)
            {
                // skip contents and set scan location after end tag
                NSString *temp;
                // skip to next tag that matches this one
                if ([mainScanner scanLocation] + [greaterThanBracket length] < [stringToParse length]-1)
                {
                    [mainScanner setScanLocation:[mainScanner scanLocation]+[greaterThanBracket length]];
                    int originalScanLocation = [mainScanner scanLocation];
                    [mainScanner scanUpToString:tagToMatch intoString:&temp];
                    [mainScanner scanUpToString:greaterThanBracket intoString:&temp];
                    
                    if (([mainScanner scanLocation]+[greaterThanBracket length]) < [stringToParse length]-1)
                    {
                        [mainScanner setScanLocation:[mainScanner scanLocation]+[greaterThanBracket length]];
                    }
                    else
                    {
                        // tag is singleton, probably an attribute
                        [mainScanner setScanLocation:originalScanLocation];
                    }
                }    
                
                
#ifdef DEBUG_SP 
                NSLog(@"\n\nDEBUG: skipping content removal tag");
#endif
            }
            else {
                subFound = NO;
                index = 0;
                // if tag is an end tag, close the last tag matching this tag kind in the tag list
                if ([scanContents rangeOfString:@"/"].location != NSNotFound)
                {
#ifdef DEBUG_SP 
                    NSLog(@"scancontents at start of end tag matching is %@",scanContents);
#endif
                    while (!subFound && index < [tags count])
                    {
                        if ([[tags objectAtIndex:index] isOfSameTagType: [self getTagTypeFromString:scanContents]] && [[tags objectAtIndex:index] isOpen])
                        {
                            [[tags objectAtIndex: index] setIsOpen: NO];
                            
#ifdef DEBUG_SP 
                            NSLog(@"\n\nDEBUG: closing tag of type %i", [[tags objectAtIndex: index] type]);
#endif
                            index++;
                        }
                        else {
                            index++;
                        }
                        
                    }
                    
#ifdef DEBUG_SP 
                    NSLog(@"scancontents at end of end tag matching is %@",scanContents);
#endif
                    // skip ahead
                    if ([mainScanner scanLocation] + [greaterThanBracket length] < [stringToParse length]-1)
                    {
                        [mainScanner setScanLocation:[mainScanner scanLocation]+[greaterThanBracket length]];
                    }			
                }
                else {
                    // create new tag
                    Tag *newTag = [[Tag alloc] init];
                    
                    [newTag setTagType: [self getTagTypeFromString:scanContents]];
                    
                    [newTag setID: tagCounter];
                    
                    tagCounter++;
                    
                    [tags addObject:newTag];
                    
#ifdef DEBUG_SP 
                    NSLog(@"\n\nDEBUG: created new tag of type %i", [newTag type]);
#endif
                    // skip ahead
                    if ([mainScanner scanLocation] + [greaterThanBracket length] < [stringToParse length]-1)
                    {
                        [mainScanner setScanLocation:[mainScanner scanLocation]+[greaterThanBracket length]];
                    }
                }
            }
            
            
            
        }
#ifdef DEBUG_SP 
        NSLog(@"Finished parsing");
        
        for (Snippet *snippet in snippets)
        {
            [snippet print];
        }
#endif
        [self cleanSnippets];
        
        int charCounter = 0;
        int snippetStart = 0;
        int snippetLength = 0;
        NSMutableString *combinedSnippets = [NSMutableString stringWithCapacity:10];
        NSMutableArray *stringsToCombine = [NSMutableArray arrayWithCapacity: 10];
        // stitch snippets back together, generating italic and bold ranges as you go
        for (Snippet *snippet in snippets)
        { 
            
            snippetStart = charCounter;
            snippetLength = [[snippet text] length];
            [combinedSnippets appendString:[snippet text]];
            //combinedSnippets = [combinedSnippets stringByAppendingString: [snippet text]];
            charCounter += snippetLength;
            
            //
            [stringsToCombine addObject: [snippet text]];
            // 
            
            if ([snippet formattingAllowed])
            {
                if ([snippet hasBoldTag])
                {
                    
                    [boldRanges addObject: NSStringFromRange(NSMakeRange(snippetStart, snippetLength))];
                }
                
                if ([snippet hasItalicTag])
                {
                    [italicRanges addObject: NSStringFromRange(NSMakeRange(snippetStart, snippetLength))];
                }
            }
        }
        
        
        // set text to be contents of combined
        fulltext = combinedSnippets;
        
#ifdef DEBUG_SP 
        NSLog(@"Combined text = %@", combinedSnippets);
#endif
        
}

-(void)cleanSnippets
{
    NSMutableArray *snippetsToKeep = [NSMutableArray arrayWithCapacity:[snippets count]];
    
    int newCount = 0;
    for (Snippet *snippet in snippets)
    {
        [snippet cleanThyself];
        if (![snippet isDud]) [snippetsToKeep addObject: snippet];
    }
    
    newCount = [snippetsToKeep count];
    
    // clear old snippets
    [snippets removeAllObjects];
    
    // re-add snippets to keep to snippets array
    for (Snippet *snippet in snippetsToKeep)
    {
        [snippets addObject: snippet];
    }
    
}

-(int)generateNewTagID
{
    return tagCounter;
    tagCounter++;
}

-(int)getTagTypeFromString:(NSString *)verboseTagType
{
	NSEnumerator *tagStringsAndTypesEnumerator = [tagStringsAndTypes keyEnumerator];
	int tag = -1;
	NSString *key = @"";
	BOOL found = NO;
	while ((key = (NSString*)[tagStringsAndTypesEnumerator nextObject]) && !found)
	{
		if ([verboseTagType rangeOfString: key].location != NSNotFound)
		{
			NSNumber *tagNbr = (NSNumber*)[tagStringsAndTypes objectForKey:key];
			tag = [tagNbr intValue];
            found = YES;
		}
	}
	return tag;
}


-(BOOL)openTagsExist
{
	BOOL found = NO;
	int index = 0;
	while (!found && index < [tags count])
	{
		Tag *tempTag = [tags objectAtIndex:index];
		
		if ([tempTag isOpen]) {
			found = YES;
		}
		else {
			index++;
		}
        
	}
	
	return found;
}


@end
