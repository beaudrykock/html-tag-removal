//
//  Snippet.h
//  smartParseTest
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
#import "Tag.h"

@interface Snippet : NSObject {
	NSString *text;
	NSMutableArray *tags;
    BOOL allowFormatting;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSMutableArray *tags;

-(void)addTag:(Tag*)newTag;
-(void)setup;
-(BOOL)hasBoldTag;
-(BOOL)hasItalicTag;
-(BOOL)isDud;
-(BOOL)formattingAllowed;
-(void)print;
-(void)cleanThyself;

@end
