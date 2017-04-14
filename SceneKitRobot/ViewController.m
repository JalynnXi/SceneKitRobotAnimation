//
//  ViewController.m
//  SceneKitRobot
//
//  Created by JalynnXi on 29/03/2017.
//  Copyright © 2017 JalynnXi. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
@interface ViewController ()
@property(strong,nonatomic)SCNView *scnView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSCNView];
    [self changecloses];
}

-(void)changecloses{
    UIButton *redbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    redbutton.frame = CGRectMake(20, 20, 120, 50);
    [redbutton setTitle:@"白色衣服" forState:UIControlStateNormal];
    [redbutton addTarget:self action:@selector(redClothes) forControlEvents:UIControlEventTouchUpInside];
    redbutton.backgroundColor  = [UIColor redColor];
    [self.view addSubview:redbutton];
    
    UIButton *purplebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    purplebutton.frame = CGRectMake(20, 80, 120, 50);
    [purplebutton setTitle:@"紫色衣服" forState:UIControlStateNormal];
    [purplebutton addTarget:self action:@selector(purpleClothes) forControlEvents:UIControlEventTouchUpInside];
    purplebutton.backgroundColor  = [UIColor redColor];
    [self.view addSubview:purplebutton];
    
    UIButton *xjxbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    xjxbutton.frame = CGRectMake(20, 140, 120, 50);
    [xjxbutton setTitle:@"❤️衣服" forState:UIControlStateNormal];
    [xjxbutton addTarget:self action:@selector(heartClothes) forControlEvents:UIControlEventTouchUpInside];
    xjxbutton.backgroundColor  = [UIColor redColor];
    [self.view addSubview:xjxbutton];
}

-(void)redClothes{
    SCNNode *shirtNode = [_scnView.scene.rootNode childNodeWithName:@"shirt" recursively:YES];
    shirtNode.geometry.firstMaterial.diffuse.contents =nil;
}

-(void)purpleClothes{
    SCNNode *shirtNode = [_scnView.scene.rootNode childNodeWithName:@"shirt" recursively:YES];
    shirtNode.geometry.firstMaterial.diffuse.contents = @"export_0_texture19.png";
}


-(void)heartClothes{
    SCNNode *shirtNode = [_scnView.scene.rootNode childNodeWithName:@"shirt" recursively:YES];
    shirtNode.geometry.firstMaterial.diffuse.contents = @"export_0_texture22.png";
}

-(void)addSCNView{
    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"skinning" withExtension:@".dae"] options:nil];
    _scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
    _scnView.allowsCameraControl = true;
    _scnView.backgroundColor  = [UIColor whiteColor];
    _scnView.scene = [sceneSource sceneWithOptions:nil error:nil];
    
    
    
    SCNNode *cameranode = [SCNNode node];
    cameranode.camera = [SCNCamera camera];
    cameranode.camera.automaticallyAdjustsZRange = true;
    cameranode.position = SCNVector3Make(0, 0, 100);
    [_scnView.scene.rootNode addChildNode:cameranode];

    
    NSArray *animationIDs = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
    NSUInteger animationCount = [animationIDs count];
    NSMutableArray *longAnimations = [[NSMutableArray alloc]initWithCapacity:animationCount];
    CFTimeInterval maxDuration = 0;
    for (NSInteger index = 0; index<animationCount; index++) {
        CAAnimation *animation = [sceneSource entryWithIdentifier:animationIDs[index] withClass:[CAAnimation class]];
        if (animation) {
            maxDuration = MAX(maxDuration, animation.duration);
            [longAnimations addObject:animation];
        }
    }
    
    CAAnimationGroup *longAnimationGroup  = [[CAAnimationGroup alloc]init];
    longAnimationGroup.animations = longAnimations;
    longAnimationGroup.duration = maxDuration;
    CAAnimationGroup *idleAnimationGroup = [longAnimationGroup copy];
    idleAnimationGroup.timeOffset = 20;
    CAAnimationGroup *lastAnimationGroup = [CAAnimationGroup animation];
    lastAnimationGroup.animations = @[idleAnimationGroup];
    lastAnimationGroup.duration = 24.71;
    lastAnimationGroup.repeatCount = 10000;
    lastAnimationGroup.autoreverses =YES;
    SCNNode *personNode = [_scnView.scene.rootNode childNodeWithName:@"avatar_attach" recursively:YES];
    SCNNode *skeletonNode = [_scnView.scene.rootNode childNodeWithName:@"skeleton" recursively:YES];
    [personNode addAnimation:lastAnimationGroup forKey:@"animation"];
    //标出骨头
//    [self visualizeBones:true ofNode:skeletonNode inheritedScale:1];
    [self.view addSubview:_scnView];
}


-(void)visualizeBones:(BOOL)show ofNode:(SCNNode*)node inheritedScale:(CGFloat)scale{
    scale = node.scale.x*scale;
    
    if (show) {
        if (node.geometry ==nil) {
            node.geometry = [SCNBox boxWithWidth:6.0/scale height:6.0/scale length:6.0/scale chamferRadius:5];
        }else if ([node.geometry isKindOfClass:[SCNBox class]]){
            node.geometry = nil;
            
        }
        for (SCNNode *child in node.childNodes)
            [self visualizeBones:show ofNode:child inheritedScale:scale];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
