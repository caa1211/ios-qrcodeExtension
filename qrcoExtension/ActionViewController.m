//
//  ActionViewController.m
//  qrcoExtension
//
//  Created by Carter Chang on 11/10/15.
//  Copyright © 2015 Carter Chang. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;


@end

@implementation ActionViewController

- (void) openDictPageWithKeyword {
        NSString *  urlstr = @"qrcc://";
        
        UIResponder* responder = self;
        while ((responder = [responder nextResponder]) != nil)
        {
            NSLog(@"responder = %@", responder);
            if([responder respondsToSelector:@selector(openURL:)] == YES)
            {
                [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:urlstr]];
            }
        }
   
    
}

- (void)openURL{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            
            
            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                // It's a plain text!
            
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *item, NSError *error) {
                    NSLog(@"Type is URL:%@",kUTTypeURL);
                    if (item) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"========URL %@==================", item.absoluteString);
                            [self openDictPageWithKeyword];
                            
                            
                            
                            
                        }];
                     }
                }];
            }

            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
