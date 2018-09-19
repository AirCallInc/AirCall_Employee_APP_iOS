//
//  SearchPartViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SearchPart <NSObject>

-(void)SelectedPartName:(ACEParts *)selectedPart;

@end

@interface SearchPartViewController : ACEViewController

@property (strong, nonatomic) NSArray  *dataArray  ;
@property (strong, nonatomic) NSArray  *searchArray;
@property (strong, nonatomic) NSString *partId     ;

@property (weak) id<SearchPart> delegate;

@property BOOL isFromAddOrder;

@end
