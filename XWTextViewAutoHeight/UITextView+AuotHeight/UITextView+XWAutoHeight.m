//
//  UITextView+XWAutoHeight.m
//  XWTextViewAutoHeight
//
//  Created by cgw on 2018/12/5.
//  Copyright © 2018 bill. All rights reserved.
//

#import "UITextView+XWAutoHeight.h"

@implementation UITextView (XWAutoHeight)

- (void)autoChangeWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight changeBlock:(XWChangeHeightBlock)changeHeightBlock{

    [self saveMaxHeight:maxHeight minHeight:minHeight];
    [self registerForKVOWithContext:(__bridge void *)(changeHeightBlock)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if( ![object isKindOfClass:[UITextView class]] ) return;
    if( ![change isKindOfClass:[NSDictionary class]] ) return;
    
    NSValue *sizeValue = change[@"new"];
    if( ![sizeValue isKindOfClass:[NSValue class]] ) return;
    
    if( context ){
        
        CGRect fr = self.frame;
        CGFloat maxHeight = 0, minHeight = 0;
        [self getMaxHeight:&maxHeight minHeight:&minHeight];
        
        CGFloat newHeight = sizeValue.CGSizeValue.height;
        
        CGFloat zeroValue = 0.000001;
        
        //若最大高度不为0，则比较最大高度
        if( maxHeight > zeroValue ){
            if( newHeight > maxHeight ){
                newHeight = maxHeight;
            }
        }
        
        //若最小高度不为0，则设置最小高度
        if( minHeight > zeroValue ){
            if( newHeight < minHeight ){
                newHeight = minHeight;
            }
        }
        
        //若textview的高度与新的高度一致，则不改变高度也不回调
        if( ABS(fr.size.height - newHeight) < zeroValue){
            return;
        }
        
        fr.size.height = newHeight;
        self.frame = fr;
        
        XWChangeHeightBlock callback = (__bridge XWChangeHeightBlock)(context);
        callback(fr.size.height);
    }
}

- (void)dealloc{
    //移除观察者
    [self unregisterFromKVO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.markKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.maxAndMinHeightKey];
}

#pragma mark - Private

- (NSString*)keyPath{
    return @"contentSize";
}

- (NSString*)markKey{
    NSString *key = [NSString stringWithFormat:@"%p",(self)];
    return key;
}

- (NSString*)maxAndMinHeightKey{
    return [[self markKey] stringByAppendingString:@"maxHeightKey"];
}
   
- (void)saveMaxHeight:(CGFloat)maxHeight minHeight:(CGFloat)minHeight{

    [[NSUserDefaults standardUserDefaults] setObject:@[@(maxHeight),@(minHeight)] forKey:[self maxAndMinHeightKey]];
}

- (void)getMaxHeight:(CGFloat*)maxHeight minHeight:(CGFloat*)minHeight{
    NSArray *arr =
    [[NSUserDefaults standardUserDefaults] objectForKey:[self maxAndMinHeightKey]];
    if( arr && [arr isKindOfClass:[NSArray class]] ){
        if( arr.count == 2 ){
            NSNumber *num = (NSNumber*)arr[0];
            *maxHeight = num.floatValue;
            
            num = (NSNumber*)arr[1];
            *minHeight = num.floatValue;
        }
    }
}

#pragma mark - 注册和移除KVO
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
