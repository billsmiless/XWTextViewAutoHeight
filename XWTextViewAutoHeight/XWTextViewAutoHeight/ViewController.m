//
//  ViewController.m
//  XWTextViewAutoHeight
//
//  Created by cgw on 2018/12/5.
//  Copyright © 2018 bill. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+XWAutoHeight.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [UITextView new];
    CGFloat ix = 20;
    textView.frame = CGRectMake(ix, 100, CGRectGetWidth(self.view.frame)-2*ix, 30);
    textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    
    
    [textView autoChangeHeightWithBlock:^(CGFloat height) {
        NSLog(@"高度改变了");
    }];
}


@end
