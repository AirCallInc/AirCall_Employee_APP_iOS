//
//  SearchUserViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol SelectedUser <NSObject>

-(void)selectedUser:(ACEClient *)user;

@end

@interface SearchUserViewController : ACEViewController


@property (weak)id<SelectedUser> delegate;
@property BOOL isWorkAreaClient          ;


@end
