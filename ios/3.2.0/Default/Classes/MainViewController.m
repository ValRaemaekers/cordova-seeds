/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  Default
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"

#define kDefaultStatusbarHeight 20

// private members
@interface MainViewController ()
@property   BOOL    statusbarAdjusted;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
    
    if (!_statusbarAdjusted)
    {
        [self adjustForStatusBar];
        _statusbarAdjusted = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _statusbarAdjusted = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

- (void)statusBarFrameDidChange:(NSNotification*)notification
{
    NSValue *rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect  newFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect  oldFrame;
    
    [rectValue getValue:&oldFrame];
    
    // only re-adjust if we are not changing orientation
    if ((newFrame.size.width == oldFrame.size.width)
    &&  (self.webView.frame.origin.y >= oldFrame.size.height))
        [self adjustForStatusBar];
}

-(void)adjustForStatusBar
{
	NSString            *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult  order = [[systemVersion substringToIndex:[@"7.0" length]] compare: @"7.0" options: NSNumericSearch];
    
	if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        CGRect                  statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat                 statusheight = MIN(statusBarFrame.size.width, statusBarFrame.size.height);
        
        if (statusheight)
        {
            CGRect	bounds = [[UIScreen mainScreen] bounds];
            
            if (statusheight > kDefaultStatusbarHeight)
            {
                bounds.origin.y = statusheight / 2;
                bounds.size.height -= statusheight;
            }
            else
            {
                bounds.origin.y = statusheight;
                bounds.size.height -= statusheight;
            }
            
            self.webView.frame = bounds;
        }
    }
}

#pragma mark UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    // Black base color for background matches the native apps
    theWebView.backgroundColor = [UIColor blackColor];

    return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */

/*

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}
*/

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

/*
   NOTE: this will only inspect execute calls coming explicitly from native plugins,
   not the commandQueue (from JavaScript). To see execute calls from JavaScript, see
   MainCommandQueue below
*/
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

- (NSString*)pathForResource:(NSString*)resourcepath;
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
