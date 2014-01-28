#Facebook SDK (v3.11.0)

#Setup
##Credentials
1. Create app in [Facebook App Dashboard](https://developers.facebook.com/apps/)
	Example: com.cvanderschuere.fbSample

2. Set values in .plist
	 * `FacebookAppID` with `App ID`
	 * `FacebookDisplayName` with `Display Name`
	 * `URL types` array with subitem array `URL Schemes` with item (`app ID` prefixed with `fb`)


#Login
[Documentation](https://developers.facebook.com/docs/ios/login-tutorial) is excellent

	//Create Login View
	FBLoginView *loginView = [[FBLoginView alloc] init];
	// Align the button in the center horizontally
	loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
	[self.view addSubview:loginView];
	

