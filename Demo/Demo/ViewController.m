//
//  ViewController.m
//  Demo
//
//  Created by loootus on 2017/5/25.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import "ViewController.h"
#import "NLAlertController.h"
#import "NLAlertAction.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *actionCountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *cancelSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAction:(id)sender {
    
    NLAlertController *alertController = [[NLAlertController alloc] init];
    alertController.titleValue = self.titleTextField.text;
    alertController.messageValue = self.subTitleTextField.text;
    
    for (int i = 0; i < self.actionCountTextField.text.integerValue; i++) {
        
        NLAlertAction *action = [NLAlertAction actionWithTitle:[NSString stringWithFormat:@"Action %d", i] style:(i % 2) ? 0 : 2 handler:^(NLAlertAction * _Nonnull action) {
            NSLog(@"Idx:%d Taped", i);
        }];
        
        [alertController addAction:action];
    }
    
    if (self.cancelSwitch.on) {
        
        NLAlertAction *cancelAction = [NLAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(NLAlertAction * _Nonnull action) {
            NSLog(@"Idx:Cancel Taped");
        }];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
