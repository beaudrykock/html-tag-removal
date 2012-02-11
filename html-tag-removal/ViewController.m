//
//  ViewController.m
//  html-tag-removal
//
//  Created by Beaudry Kock on 2/10/12.
//  Copyright (c) 2012 Better World coding. All rights reserved.
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *unparsedHTML = @"<p itemprop=\"articleBody\">"
    @"BRUSSELS &mdash; At the same meeting where Greece&rsquo;s latest economic plans were greeted with blunt skepticism, a television microphone accidentally recorded a very different exchange between a minister from Germany and a colleague from another bailout recipient, Portugal.        </p>      <p itemprop=\"articleBody\">"
    @"If Lisbon, which faces an austerity-driven economic slump similar to Greece&rsquo;s, needed to ease its bailout terms, &ldquo;we would be ready to do it,&rdquo; said the German finance minister, Wolfgang Sch&auml;uble.        </p><p itemprop=\"articleBody\">"
    @"&ldquo;That&rsquo;s much appreciated,&rdquo; replied his counterpart from Portugal, Vitor Gaspar.        </p><p itemprop=\"articleBody\">"
    @"The conversation, broadcast on the private Portuguese network TVI, illustrated a stark fact as the euro zone&rsquo;s <a href=\"http://topics.nytimes.com/top/reference/timestopics/subjects/e/european_sovereign_debt_crisis/index.html?inline=nyt-classifier\" title=\"More articles about the European sovereign debt crisis.\" class=\"meta-classifier\">debt crisis</a> enters its third year: While Portugal, Ireland and other countries may be struggling, Greece has found itself in a category of its own &mdash; a nation the rest of Europe no longer trusts.        </p><p itemprop=\"articleBody\">";
    
    SmartParse *smp = [[SmartParse alloc] init];
    [smp setFulltext: unparsedHTML];
    [smp parse];
    NSLog(@"parsed = %@",[smp fulltext]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
