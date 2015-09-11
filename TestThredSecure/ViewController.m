//
//  ViewController.m
//  TestThredSecure
//
//  Created by JC_CP3 on 15/9/11.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//  线程同步

#import "ViewController.h"
#import "CustomOPeration.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    NSUInteger ticketCount;
    NSMutableArray *aryData;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ticketCount = 10;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    aryData = [@[@"添加互斥锁", @"实现线程队列控制同一时刻不访问同一资源"] mutableCopy];
}

- (void)createThreadByNSThread
{
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
}

- (void)createThreadByOperationQueue
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    NSInvocationOperation *operation3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    [operationQueue addOperation:operation1];
    [operationQueue addOperation:operation2];
    [operationQueue addOperation:operation3];
}

- (void)createThreadByOperationQueueWithSubOperaion
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saleTickets];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saleTickets];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saleTickets];
    }];
    [operationQueue addOperations:@[operation1,operation2,operation3] waitUntilFinished:YES];
}

- (void)createThreadByOperationQueueWithCustomOperation
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    CustomOPeration *customOperation1 = [[CustomOPeration alloc] init];
    CustomOPeration *customOperation2 = [[CustomOPeration alloc] init];
    CustomOPeration *customOperation3 = [[CustomOPeration alloc] init];
    [operationQueue addOperations:@[customOperation1,customOperation2,customOperation3] waitUntilFinished:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)saleTickets
{
    while (1) {
        //添加@synchorized互斥锁
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

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [aryData objectAtIndex:indexPath.row];
    return cell;
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
