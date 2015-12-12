# UIViewController-SegueBlocks
Allows you to clean up your code by using blocks when you need to add custom code to segues.


You can use this class extention on UIViewController to use blocks with segues.

```obj-c
//performSegueWithIdentifier:block simply performs a segue with a block.
[self performSegueWithIdentifier:@"mySegueIdentifier" block:^(UIViewController *sourceViewController, MyViewController *destinationViewController) {
	destinationViewController.myProperty = @"Cool Stuff";
}];
```

```obj-c
//setDefaultBlockForIdentifier:block: is used to provide default behavior when a segue is used. This would be useful if you don't perform the segue in code and instead the storyboard does it for you.
[self setDefaultBlockForIdentifier:@"mySegueIdentifier" block:^(id sourceViewController, MyViewController *destinationViewController) {
	destinationViewController.myProperty = @"Cool Stuff";
}];
```

This ultimately replaces code such as this below and helps keep functionality local to where its needed.

```obj-c
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"segueIdentifier1"]) {
        MyViewController1 *viewController1 = (MyViewController1 *)segue.destinationViewController;
        viewController1.myProperty = @"Cool Stuff";
    } else if ([segue.identifier isEqualToString:@"segueIdentifier2"]) {
        MyViewController2 *viewController2 = (MyViewController2 *)segue.destinationViewController;
        viewController2.myProperty = @"Cool Stuff";
    } else if ([segue.identifier isEqualToString:@"segueIdentifier3"]) {
        MyViewController3 *viewController3 = (MyViewController3 *)segue.destinationViewController;
        viewController3.myProperty = @"Cool Stuff";
    }
}
```