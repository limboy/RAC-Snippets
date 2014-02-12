//
//  RSViewModel.h
//  RAC-Snippets
//
//  Created by Limboy on 2/12/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSViewModel : NSObject
@property (nonatomic) RACSignal *fetchedImage;
@property (nonatomic) RACCommand *fetchImageCommand;
@end
