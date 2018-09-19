//
//  DirectionCell.h
//  AircallEmployee
//
//  Created by ZWT111 on 27/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDirection;

-(void)setCellData :(MKRouteStep *)step;

@end
