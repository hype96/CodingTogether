//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Robert Cole on 6/29/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userAlreadyEnteredADecimal;
@property (nonatomic, strong) CalculatorBrain *brain;

- (void)resetStatesForNumberEntry;

- (void)appendDigitToDisplay:(NSString *)digitAsString;
- (void)appendStringToHistroyDisplay:(NSString *)stringToAppend withPrependedSpace:(BOOL)prependSpace;

@end

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userAlreadyEnteredADecimal;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc]init];
    }
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    [self appendDigitToDisplay:digit];

}

- (IBAction)decimalPressed {
    if (!self.userAlreadyEnteredADecimal) {
        [self appendDigitToDisplay:@"."];
        
        self.userAlreadyEnteredADecimal = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    [self appendStringToHistroyDisplay:self.display.text withPrependedSpace:YES];
    
    [self resetStatesForNumberEntry];
}

- (IBAction)clearPressed {
    [self.brain clearAllOperands];
    self.display.text = @"0";
    [self resetStatesForNumberEntry];
    self.historyDisplay.text = @"";
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    
    [self appendStringToHistroyDisplay:operation withPrependedSpace:YES];
    
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)resetStatesForNumberEntry {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userAlreadyEnteredADecimal = NO;
}

- (void)appendDigitToDisplay:(NSString *)digitAsString {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digitAsString];
    } else {
        self.display.text = digitAsString;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (void)appendStringToHistroyDisplay:(NSString *)stringToAppend withPrependedSpace:(BOOL)prependSpace {
    if (prependSpace && self.historyDisplay.text != @"") {
        self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    }
    
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:stringToAppend];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
