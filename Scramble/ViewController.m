//
//  ViewController.m
//  Scramble
//
//  Created by Dengke Li on 8/17/13.
//  Copyright (c) 2013 Dengke Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     [self basicsetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)run:(id)sender {

    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            NSString *current = [letterArray valueForKey:[NSString stringWithFormat:@"%i%i",i,j]];
            NSLog(@"%@",current);
            NSMutableArray *used=[[NSMutableArray alloc]init];
            [used addObject:[NSString stringWithFormat:@"%i%i",i,j]];

            [self getAround:current withi:i withj:j withUsed:used];
          

        }
    }
    myTextView.text=@"Result";
    for (int k=16; k>1; k--) {
        NSMutableArray* resultlist = [WordArray valueForKey:[NSString stringWithFormat:@"%d",k]];
        if ([resultlist count]) {
            myTextView.text=[myTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@",resultlist]];
        }
    }
    
    
}

-(void)getAround:(NSString *)current withi:(int)i withj:(int)j withUsed:(NSMutableArray *)oldUsed {
    NSString *next=@"";
    if ([self searchForWord:current]) {
        if ([[WordArray valueForKey:[NSString stringWithFormat:@"%i",[current length]]] indexOfObject:current]==NSNotFound)
            [[WordArray valueForKey:[NSString stringWithFormat:@"%i",[current length]]] addObject:current];
    }


    for (int row=-1; row<=1; row++) {
        
        for (int clot=-1; clot<=1; clot++) {
            if(clot!=0||row!=0){
                if((i+row)>=0&&(j+clot)>=0&&(j+clot)<4&&(i+row)<4){
                    if ([oldUsed indexOfObject:[NSString stringWithFormat:@"%i%i",i+row,j+clot]]==NSNotFound) {
                        
                        
                        next=[current stringByAppendingString:[letterArray valueForKey:[NSString stringWithFormat:@"%i%i",i+row,j+clot]]];
                        NSLog(@"%@",next);
                        NSLog(@"%@",oldUsed);


                        NSMutableArray *used =[[NSMutableArray alloc]initWithArray:oldUsed copyItems:YES];
                        
                        [used addObject:[NSString stringWithFormat:@"%i%i",i+row,j+clot]];
                        @autoreleasepool {
                            [self getAround:next withi:i+row withj:j+clot withUsed:used];

                        }
                    }
                }
            }
        }
    }
    

}

-(Boolean)searchForWord:(NSString *)searchTerm
{
    if([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:searchTerm])
    {
        NSLog(@"%@ found",searchTerm);
        return YES;
    }
    else
    {
        NSLog(@"%@ no found",searchTerm);
        return NO;
    }
}

-(void)basicsetup{
    NSLog(@"basic setup");
    letterArray=[[NSMutableDictionary alloc] init];

       
    WordArray= [[NSMutableDictionary alloc] init];
 
    for (int i=2; i<=16; i++) {
        NSMutableArray *word =[[NSMutableArray alloc] init];
        [WordArray setObject:word forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    if([self inputCheck]){
        NSLog(@"input format correct");
    }
    
    
    
    NSLog(@"%@",letterArray);
    NSLog(@"%@",WordArray);

    

}

-(void)searchCircleWithUsed:(NSMutableArray *) used{
    
    for (int i =0; i<[used count]; i++) {
        NSString *circleWord=@"";

        for (int j=0; j<[used count]; j++) {
            int k=i+j;
            if (k>=[used count]) {
                k=k-[used count];
            }
            circleWord=[circleWord stringByAppendingString:[NSString stringWithFormat:@"%@",[letterArray objectForKey:[NSString stringWithFormat:@"%@",[used objectAtIndex:k]]]]];
        }
        NSLog(@"circle word='%@'",circleWord);
    }
}

-(Boolean)inputCheck{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"puzzle" ofType:@"txt" inDirectory:@"dir"];
    int i=0;
    int charPerline=0;
    int currentLine=1;
    
    
    NSString * fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    fileContents = [fileContents stringByTrimmingCharactersInSet:whitespace];
    
    NSInteger length = [[fileContents componentsSeparatedByCharactersInSet:
                         [NSCharacterSet newlineCharacterSet]] count];
    NSLog(@"line = %d",length);
    
    if (length!=4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"Wrong line number %i",length]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        myTextView.text=[NSString stringWithFormat:@"Wrong line number %i",length];
        return NO;

        
    }else{
        
        while (i<[fileContents length]) {
            NSLog(@"%i",i);
            if([fileContents characterAtIndex:i] !='\n'){
                [letterArray setObject:[NSString stringWithFormat:@"%c",[fileContents characterAtIndex:i]] forKey:[NSString stringWithFormat:@"%d%d",i/5,i%5]];
                charPerline++;
            }
            else{
                NSLog(@"charPerline =%d",charPerline);
                if(charPerline !=4){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[NSString stringWithFormat:@"Malformed input at line %d",currentLine]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    myTextView.text=[NSString stringWithFormat:@"Malformed input at line %d",currentLine];

                    return NO;
                }else{
                    charPerline=0;
                    currentLine++;
                }
                
            }
            i++;
        }
    }
    if(charPerline !=4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"Malformed input at line %d",currentLine]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        myTextView.text=[NSString stringWithFormat:@"Malformed input at line %d",currentLine];
        
        return NO;
    }
    
    myTextView.text=[NSString stringWithFormat:@"Input \n %@",fileContents];
    return YES;
    
}

- (IBAction)build:(id)sender {
    UIReferenceLibraryViewController *referenceLibraryVC = [[UIReferenceLibraryViewController alloc] initWithTerm:@"ldl"];
    [self presentViewController:referenceLibraryVC animated:YES completion:nil];

}
@end
