//
//  SmartParse.h
//  html-tag-removal
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "Snippet.h"
#import "Tag.h"
#import <Foundation/Foundation.h>

enum {
    NSEnterCharacter                = 0x0003,
    NSBackspaceCharacter            = 0x0008,
    NSTabCharacter                  = 0x0009,
    NSNewlineCharacter              = 0x000a,
    NSFormFeedCharacter             = 0x000c,
    NSCarriageReturnCharacter       = 0x000d,
    NSBackTabCharacter              = 0x0019,
    NSDeleteCharacter               = 0x007f,
    NSLineSeparatorCharacter        = 0x2028,
    NSParagraphSeparatorCharacter   = 0x2029
};

@interface SmartParse : NSObject
{
    NSMutableArray *boldRanges;
	NSMutableArray *italicRanges;
    NSString *fulltext;
    NSMutableArray *snippets;
	NSMutableArray *tags;
	NSDictionary *tagStringsAndTypes;
    int tagCounter;
}

@property (nonatomic, strong) NSMutableArray *boldRanges;
@property (nonatomic, strong) NSMutableArray *italicRanges;
@property (nonatomic, strong) NSString *fulltext;
@property (nonatomic, retain) NSMutableArray *snippets;
@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) NSDictionary *tagStringsAndTypes;

-(void)parse;
-(void)cleanSnippets;
-(BOOL)openTagsExist;
-(int)generateNewTagID;
-(int)getTagTypeFromString:(NSString *)verboseTagType;

@end
