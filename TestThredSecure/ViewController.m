//
//  ViewController.m
//  TestThredSecure
//
//  Created by JC_CP3 on 15/9/11.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//  线程同步

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSUInteger ticketCount;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ticketCount = 10;
    
    [NSThread detachNewThreadSelector:@selector(saleTickets) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(saleTickets) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(saleTickets) toTarget:self withObject:nil];
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    thread1.name = @"售票员1";
    thread2.name = @"售票员2";
    thread3.name = @"售票员3";
    [thread1 start];
    [thread2 start];
    [thread3 start];
    
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
//    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
//    NSInvocationOperation *operation3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
//    [operationQueue addOperation:operation1];
//    [operationQueue addOperation:operation2];
//    [operationQueue addOperation:operation3];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)saleTickets
{
    while (1) {
        @synchronized (self) {
            NSUInteger count = ticketCount;
            if (count <= 0) {
                [NSThread exit];
            } else {
                ticketCount = count - 1;
                NSLog(@"%@------%ld",[NSThread currentThread].description, ticketCount);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
