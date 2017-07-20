//
//  QRCodeViewController.m
//  Pan_SdP
//
//  Created by tarena on 16/3/17.
//  Copyright © 2016年 LSPan. All rights reserved.
//

#import "QRCodeViewController.h"

@import AVFoundation;

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *layer;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     1.打开手机的后置摄像头
     2.通过摄像头读取数据流(输入流)
     3.搭建一个管道, 输入流通过管道输出到屏幕上(输出流)
     4.在输出时, 不断监测输出的内容, 如果监测到有二维码/条形码则通过代理方法通知我们
     */
    //Capture 捕获 Device设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //从设备中读取数据 -- 输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    //输出流
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [AVCaptureSession new];
    //设置传输质量
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session addOutput:output];
    [self.session addInput:input];
    //设置输出流的数据类型, 这个代码必须在管道连接完毕以后写, 否则崩溃, 条形码加二维码
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeCode128Code];
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layer.frame = self.view.frame;
    //内容为铺满
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.layer];
    //启动管道
    [self.session startRunning];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.session startRunning];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate 代理方法
//当捕获到二维码的时候触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        //关闭管道
        [self.session stopRunning];
        //删除摄像内容
        [self.layer removeFromSuperlayer];
        if ([obj.stringValue containsString:@"http"]  || [obj.stringValue containsString:@"https"] ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.stringValue]];
        }
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
