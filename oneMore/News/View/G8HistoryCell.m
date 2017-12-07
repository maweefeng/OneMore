//
//  G8HistoryCell.m
//  Template Framework Project
//
//  Created by Weefeng Ma on 2017/11/13.
//  Copyright © 2017年 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8HistoryCell.h"
#import "G8HistoryModel.h"
@interface G8HistoryCell()<CAAnimationDelegate>
@property(nonatomic,assign)CGPoint clickPoint;
@property(nonatomic,strong)CAReplicatorLayer *replicatorLayer;
@property(nonatomic,strong)CAShapeLayer *pulseLayer;
@property(nonatomic,strong)UIImageView * imgV;
@property(nonatomic,assign)CGRect  newRect;

@end


@implementation G8HistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
       
        
    }
    return self;
    
    
}
-(CAReplicatorLayer *)replicatorLayer{
    if (!_replicatorLayer) {
        _replicatorLayer = [CAReplicatorLayer layer];
    }
    return _replicatorLayer;
}
-(CAShapeLayer *)pulseLayer{
    
    if (!_pulseLayer) {
        _pulseLayer = [CAShapeLayer layer];
    }
    return _pulseLayer;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(G8HistoryModel *)model{
    _model =model;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.model.pic] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"%ld",(long)receivedSize);
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(finished&&image){
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //开启图形上下文
                UIGraphicsBeginImageContext(self.newRect.size);
                //绘制图片
                [image drawAsPatternInRect:self.newRect];
                //关闭图形上下文
                UIGraphicsEndImageContext();
                
//                [self setNeedsDisplay];
            });

        }
    }];
//    [_imgV sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:nil];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if ([self.contentView pointInside:point withEvent:event]) {
        
        self.clickPoint= point;
        NSLog(@"%f ---- %f",self.clickPoint.x,self.clickPoint.y);
        [self setNeedsDisplay];
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
    
}
- (void)setup
{
    [self.layer removeAllAnimations];
    //CAShapeLayer和CAReplicatorLayer都是CALayer的子类
    //CAShapeLayer的实现必须有一个path，可以配合贝塞尔曲线
    self.pulseLayer.frame = CGRectMake(0, 0, 50, 50);
    self.pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.pulseLayer.bounds].CGPath;
    self.pulseLayer.fillColor = [UIColor redColor].CGColor;//填充色
    self.pulseLayer.opacity = 0.0;
    
    //可以复制layer
    self.replicatorLayer.bounds = CGRectMake(0, 0, 50, 50);
    self.replicatorLayer.position = self.clickPoint;
    self.replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
    self.replicatorLayer.instanceDelay = 1;//复制副本之间的延迟
    [self.replicatorLayer addSublayer:self.pulseLayer];
    [self.layer addSublayer:self.replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    opacityAnima.delegate = self;
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 2.0;
    groupAnima.delegate = self;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = 1;
    [self.pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    
}

-(void)drawRect:(CGRect)rect{
    CGRect newRect = CGRectMake(20, 10, rect.size.width-40, rect.size.height-20);
    self.newRect = newRect;
    UIImage * image = [UIImage imageNamed:@"rocket"];
    [self drawLine:newRect];
    //绘制图片
    [image drawAsPatternInRect:self.newRect];

    //加阴影--任海丽编辑
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping; // 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    textStyle.alignment = NSTextAlignmentLeft; //（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    textStyle.lineSpacing = 5; // 字体的行间距
    textStyle.firstLineHeadIndent = 5.0; // 首行缩进
    textStyle.headIndent = 0.0; // 整体缩进(首行除外)
    textStyle.tailIndent = 0.0; //
    textStyle.minimumLineHeight = 20.0; // 最低行高
    textStyle.maximumLineHeight = 20.0; // 最大行高
    textStyle.paragraphSpacing = 15; // 段与段之间的间距
//    textStyle.paragraphSpacingBefore = 22.0f; // 段首行空白空间/* Distance between the bottom of the PRevious paragraph (or the end of its paragraphSpacing, if any) and the top of this paragraph. */
    textStyle.baseWritingDirection = NSWritingDirectionLeftToRight; // 从左到右的书写方向（一共➡️三种）
//    textStyle.lineHeightMultiple = 15; /* Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. */
    textStyle.hyphenationFactor = 1; //连字属性 在iOS，唯一支持的值分别为0和1
    // 文本属性
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *textAttribute = [[NSMutableDictionary alloc] init];
    // NSParagraphStyleAttributeName 段落样式
    [textAttributes setValue:textStyle forKey:NSParagraphStyleAttributeName];
     [textAttribute setValue:textStyle forKey:NSParagraphStyleAttributeName];
    // NSFontAttributeName 字体名称和大小
    [textAttributes setValue:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName];
    [textAttribute setValue:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName];
    // NSForegroundColorAttributeNam 颜色
    [textAttributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [textAttribute setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    CGRect rect1 = CGRectMake(newRect.origin.x+10, newRect.origin.y+2, newRect.size.width, 20);
    // 绘制文字
    [self.model.title drawInRect:rect1 withAttributes:textAttributes];
    CGRect rect2 = CGRectMake(newRect.origin.x+10, newRect.origin.y+28, newRect.size.width-20, newRect.size.height- 28-10);
    [self.model.des drawInRect:rect2 withAttributes:textAttribute];
    if (self.clickPoint.x != 0) {
        
        [self setup];
    }
    
    
    
}
/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim{
    
    
}
-(void)drawLine:(CGRect)rect{
   
    [[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]setFill];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft| UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path addClip];
    [path fill];

}
/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.clickPoint = CGPointMake(0, 0);
    [self.layer removeAllAnimations];
}

@end
