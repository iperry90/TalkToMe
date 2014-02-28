//
//  SpeechViewController.m
//  BroTalk
//
//  Created by Ian Perry on 11/1/13.
//  Copyright (c) 2013 iperry. All rights reserved.
//

#import "SpeechViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface SpeechViewController () <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UISlider *speed;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIPickerView *languagePickerView;
@property (strong,nonatomic) AVSpeechSynthesizer *synthesizer;
@property float speedValue;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSArray *voices;

@end

@implementation SpeechViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.speed.minimumValue = 0.1;
    self.speed.maximumValue = 1.0;
    
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    self.languagePickerView.delegate = self;
    self.languagePickerView.dataSource = self;
    
    self.voices = [AVSpeechSynthesisVoice speechVoices];
}

- (IBAction)speedSlider:(id)sender {
    self.speedValue = self.speed.value;
    NSLog(@"%f",self.speed.value);
}

// dismiss the keyboard, could be done a better way, but good for now
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}


- (IBAction)speakPressed:(id)sender {
    NSInteger langVal = [self.languagePickerView selectedRowInComponent:0];
    
    self.language = [[self.voices objectAtIndex:langVal] language];
    
    AVSpeechUtterance *talk = [[AVSpeechUtterance alloc] initWithString:self.textView.text];
    [talk setRate:self.speedValue];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.language];
    [talk setVoice:voice];
    
    [self.synthesizer speakUtterance:talk];
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.voices count];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.voices objectAtIndex:row] language];
    
}

@end
