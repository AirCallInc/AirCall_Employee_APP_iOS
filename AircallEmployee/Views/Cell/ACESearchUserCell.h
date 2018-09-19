//
//  ACESearchUserCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACESearchUserCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblClientEmail;

-(void)setCellData:(ACEClient*)client;

@end
