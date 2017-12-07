//
//  AccessView.m
//  oneMore
//
//  Created by Weefeng Ma on 2017/11/17.
//  Copyright © 2017年 maweefeng. All rights reserved.
//

#import "AccessView.h"
#import <WebKit/WebKit.h>
@interface AccessView()
@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)WKWebView * wkwebView;
@end
@implementation AccessView
-(UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc]initWithFrame:self.frame];
    }
    return _webView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        _webView.frame = frame;
        [self addSubview:_webView];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
