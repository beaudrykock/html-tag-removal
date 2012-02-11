//
//  Tag.m
//  smartParseTest
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "Tag.h"


@implementation Tag

-(BOOL)isOfSameTagType:(int)type
{
	if (tagType == type) return YES;
		
	return NO;
}

-(int)tagType
{
	return tagType;
}

-(void)setTagType: (int)typeToSet
{
	tagType = typeToSet;
	isOpen = YES;
}

-(BOOL)isOpen
{
	return isOpen;
}

-(void)setIsOpen:(BOOL)openState
{
	isOpen = openState;
}

-(void)setID:(int)idToSet
{
    ID = idToSet;
}

-(BOOL)isParagraph
{
    if (tagType == kParagraphType)
        return YES;
    return NO;
}

-(void)print
{
    NSLog(@"Tag type = %@", [self tagTypeToString: tagType]);
    NSLog(@"Tag ID = %i", ID);
}

-(NSString *)typeToString:(int)typeAsInt
{
    NSString *typeAsString;
    switch(typeAsInt)
    {
        case 0: typeAsString = @"paragraph"; break;
        case 1: typeAsString = @"bold"; break;
        case 2: typeAsString = @"italic"; break;
        case 3: typeAsString = @"line break"; break;
        default: typeAsString = @"no type"; break;
    }
    
    return typeAsString;
}

@end
