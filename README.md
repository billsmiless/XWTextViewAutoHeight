# XWTextViewAutoHeight

一行代码实现UITextView自适应高度

使用类别的方式实现自动改变textview的高度，实现0侵入

使用方式：

1. 将本项目中的 UITextView+AuotHeight 文件夹中的代码拷贝至你的项目

2. 导入 #import "UITextView+XWAutoHeight.h" 头文件到你所需要用的textview所在的文件

3. 使用textview实例调用，调用开启自动改变高度方法，如下：
- (void)autoChangeHeightWithBlock:(XWChangeHeightBlock)changeHeightBlock;
这个方法只能调用一次，调用多次的话，只有第一次的生效。

4. changeHeightBlock 是高度改变后的回调。   
