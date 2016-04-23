//
//  ViewController.m
//  ResearchKitDemo
//
//  Created by Shubham Sorte on 23/04/16.
//  Copyright © 2016 Shubham Sorte. All rights reserved.
//

#import "ViewController.h"
#import "StepFeedbackViewController.h"

@interface ViewController () <ORKTaskViewControllerDelegate>
{
    ORKInstructionStep *myStep;
    ORKQuestionStep * feedbackStep;
    ORKFormStep * formStep;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        myStep = [[ORKInstructionStep alloc] initWithIdentifier:@"intro"];
        myStep.title = @"Have time for today's feedback?";
        
        //    feedbackStep = [[ORKQuestionStep alloc] initWithIdentifier:@"feedbackStep"];
        //    feedbackStep.title = @"Write your feedback";
        
        formStep = [[ORKFormStep alloc] initWithIdentifier:@"form" title:@"Feedback" text:@""];
        ORKFormItem * feedbackItem = [[ORKFormItem alloc] initWithIdentifier:@"formItem" text:@"Give your Feedback" answerFormat:[ORKAnswerFormat textAnswerFormat] optional:NO];
        formStep.formItems = @[feedbackItem];
        
        ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:@"task" steps:@[myStep,formStep]];
        
        ORKTaskViewController *taskViewController =
        [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
        taskViewController.delegate = self;
        
        [self presentViewController:taskViewController animated:YES completion:nil];
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ORKTaskView Delegate Method

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error {
    ORKTaskResult *taskResult = [taskViewController result];
    // You could do something with the result here.
    ORKStepResult * finalResult = (ORKStepResult*)[taskResult.results lastObject];
    NSLog(@"Results : %@",[[finalResult.results firstObject] valueForKey:@"answer"]);
    // Then, dismiss the task view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nullable ORKStepViewController *)taskViewController:(ORKTaskViewController *)taskViewController viewControllerForStep:(ORKStep *)step {
    
    if (step == formStep) {
        StepFeedbackViewController * vc;
        return vc;
    }
    
    return nil;
}

@end
