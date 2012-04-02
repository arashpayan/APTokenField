Introduction
------------
APTokenField is a class that behaves similarly to the 'To:' field in iOS's MFMailComposeViewController. Similar functionality can be found in [Three20] [three20]'s `TTPickerTextField`, but it's hard to use and requires integrating the entire Three20 framework into your app to take advantage of it. It's been tested on iOS 4.0 and and later (including iPad), and the code is released under the BSD 3-clause license. To find out more, check out the [project homepage] [homepage].

[![](http://arashpayan.com/blog/wp-content/uploads/2012/04/demo_screen_shot-200x300.png)](http://arashpayan.com/blog/wp-content/uploads/2012/04/demo_screen_shot.png)
[![](http://arashpayan.com/blog/wp-content/uploads/2012/04/line2_screen_shot-200x300.png)](http://arashpayan.com/blog/wp-content/uploads/2012/04/line2_screen_shot.png)

Getting Started
---------------
1. Add `APTokenField.h` and `APTokenField.m` into your project.
2. Add the `CoreGraphics` and `QuartzCore` frameworks to your project.
3. Create an object that conforms to the `APTokenFieldDataSource` protocol to use as the data source for your `APTokenField` instance.
4. Create an instance of an `APTokenFieldView`, assign your `APTokenFieldDataSource` to it's `tokenFieldDataSoure` property then add the token field to your view hierarchy.

License
-------
Copyright 2012. [Arash Payan] [arash].
This library is distributed under the terms of the [BSD 3-clause license] [bsd] ("BSD New" or "BSD Simlpified").

While not required, I greatly encourage and appreciate any improvements that you make to this library be contributed back for the benefit of all who use APTokenField.

[homepage]: http://arashpayan.com/blog/2012/04/01/introducing-aptokenfield/
[three20]: https://github.com/facebook/three20
[arash]: http://arashpayan.com
[bsd]: http://en.wikipedia.org/wiki/BSD_licenses#3-clause_license_.28.22New_BSD_License.22_or_.22Modified_BSD_License.22.29