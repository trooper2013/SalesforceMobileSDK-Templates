/*
 Copyright (c) 2011-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#import "InitialViewController.h"
#import "RootViewController.h"
#import <SalesforceSDKCore/SFSDKAppConfig.h>
#import <SalesforceSDKCore/SFPushNotificationManager.h>
#import <SalesforceSDKCore/SFDefaultUserManagementViewController.h>
#import <SalesforceSDKCore/SalesforceSDKManager.h>
#import <SalesforceSDKCore/SFUserAccountManager.h>
#import <SmartSync/SmartSyncSDKManager.h>
#import <SmartSync/SFSDKSmartSyncLogger.h>
#import <SalesforceSDKCore/SFLoginViewController.h>
#import <SalesforceSDKCore/SFSDKLoginViewControllerConfig.h>
#import <SalesforceSDKCore/SFSDKAuthHelper.h>

@interface AppDelegate ()

/**
 * Convenience method for setting up the main UIViewController and setting self.window's rootViewController
 * property accordingly.
 */
- (void)setupRootViewController;

/**
 * (Re-)sets the view state when the app first loads (or post-logout).
 */
- (void)initializeAppViewState;

@end

@implementation AppDelegate

@synthesize window = _window;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SmartSyncSDKManager initializeSDK];
        
        //App Setup for any changes to the current authenticated user
        __weak typeof (self) weakSelf = self;
        [SFSDKAuthHelper registerBlockForCurrentUserChangeNotifications:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf resetViewState:^{
                [strongSelf setupRootViewController];
            }];
        }];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self initializeAppViewState];
    
  
    //Uncomment the code below to see how you can customize the color, textcolor, font and   fontsize of the navigation bar
    //SFSDKLoginViewControllerConfig *loginViewConfig = [[SFSDKLoginViewControllerConfig  alloc] init];
    //Set showSettingsIcon to NO if you want to hide the settings icon on the nav bar
    //loginViewConfig.showSettingsIcon = YES;
    //Set showNavBar to NO if you want to hide the top bar
    //loginViewConfig.showNavbar = YES;
    //loginViewConfig.navBarColor = [UIColor colorWithRed:0.051 green:0.765 blue:0.733 alpha:1.0];
    //loginViewConfig.navBarTextColor = [UIColor whiteColor];
    //loginViewConfig.navBarFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    //[SFUserAccountManager sharedInstance].loginViewControllerConfig = loginViewConfig;
    __weak typeof (self) weakSelf = self;
    [SFSDKAuthHelper loginIfRequired:^{
        [weakSelf setupRootViewController];
    }];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
    // Uncomment the code below to register your device token with the push notification manager
    //
    // [[SFPushNotificationManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    // if ([SFUserAccountManager sharedInstance].currentUser.credentials.accessToken != nil) {
    //     [[SFPushNotificationManager sharedInstance] registerSalesforceNotificationsWithCompletionBlock:nil failBlock:nil];
    // }
    //
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // Respond to any push notification registration errors here.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

    // If you're using advanced authentication:
    // --Configure your app to handle incoming requests to your
    //   OAuth Redirect URI custom URL scheme.
    // --Uncomment the following line and delete the original return statement:

    // return [[SFUserAccountManager sharedInstance] handleAdvancedAuthenticationResponse:url options:options];
    return NO;
}

#pragma mark - Private methods

- (void)initializeAppViewState
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initializeAppViewState];
        });
        return;
    }

    self.window.rootViewController = [[InitialViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
}

- (void)setupRootViewController
{
    RootViewController *rootVC = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = navVC;
}

- (void)resetViewState:(void (^)(void))postResetBlock
{
    if ((self.window.rootViewController).presentedViewController) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            postResetBlock();
        }];
    } else {
        postResetBlock();
    }
}

@end
