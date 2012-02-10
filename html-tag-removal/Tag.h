//
//  Tag.h
//  smartParseTest
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
// definitions of types once tag has been created
#define kParagraphType 0
#define kBoldType 1
#define kItalicType 2
#define kLineBreakType 3 

// definitions of tag opener and closer strings 
#define kParagraph @"p"
#define kStrong @"strong"
#define kEm @"em"
#define kI @"i"
#define kB @"b"
#define kBr @"br /"
#define kOl @"ol"
#define kUl @"ul"

@interface Tag : NSObject {
	
	int type;
	BOOL isOpen;
    int ID;
	
}

-(void)setIsOpen:(BOOL)openState;
-(BOOL)isOfSameTagType:(int)tagType;
-(void)setID:(int)idToSet;
-(BOOL)isParagraph;
-(int)type;
-(void)setType:(int)typeToSet;
-(BOOL)isOpen;
-(void)setIsOpen:(BOOL)openState;
-(void)print;
-(NSString*)typeToString:(int)typeAsInt;

@end
