//
//  ViewController.h
//  Scramble
//
//  Created by Dengke Li on 8/17/13.
//  Copyright (c) 2013 Dengke Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSMutableDictionary *WordArray;
    NSMutableDictionary *letterArray;


    
    
    
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *run;
- (IBAction)run:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
- (IBAction)build:(id)sender;

@end
