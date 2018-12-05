//
//  UITextView+XWAutoHeight.m
//  XWTextViewAutoHeight
//
//  Created by cgw on 2018/12/5.
//  Copyright © 2018 bill. All rights reserved.
//

#import "UITextView+XWAutoHeight.h"

@implementation UITextView (XWAutoHeight)

- (void)autoChangeHeightWithBlock:(XWChangeHeightBlock)changeHeightBlock{
    [self registerForKVOWithContext:(__bridge void * _Nullable)(changeHeightBlock)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if( ![object isKindOfClass:[UITextView class]] ) return;
    
    if( ![change isKindOfClass:[NSDictionary class]] ) return;
    
    NSValue *sizeValue = change[@"new"];
    
    if( ![sizeValue isKindOfClass:[NSValue class]] ) return;
    
    CGRect fr = self.frame;
    fr.size.height = sizeValue.CGSizeValue.height;
    self.frame = fr;
    
    if( context ){
        XWChangeHeightBlock callback = (__bridge XWChangeHeightBlock)context;
        callback(fr.size.height);
    }
}

- (void)dealloc{
    //移除观察者
    [self unregisterFromKVO];
}

#pragma mark - Private

- (NSString*)keyPath{
    return @"contentSize";
}

- (NSString*)markKey{
    NSString *key = [NSString stringWithFormat:@"%p",(&self)];
    return key;
}

- (void)registerForKVOWithContext:(void*)context {
    
    //若已经添加过KVO，则不再添加
    if( [[NSUserDefaults standardUserDefaults] boolForKey:self.markKey] ){
        NSLog(@"已添加过观察者，本次添加会被忽略");
        return;
    }
    
    [self addObserver:self forKeyPath:self.keyPath options:(NSKeyValueObservingOptionNew) context:context];
    
    //添加一个标记，用来标记已经添加过观察者，为了移除观察者
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.markKey];
}

- (void)unregisterFromKVO {
    if( [[NSUserDefaults standardUserDefaults] boolForKey:self.markKey] ){
        [self removeObserver:self forKeyPath:self.keyPath];
    }
}

@end
