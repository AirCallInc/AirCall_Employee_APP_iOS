//
//  AddNewOrderViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddNewOrderViewController.h"

@interface AddNewOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SearchPart,ZWTTextboxToolbarHandlerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtfselectItem;
@property (strong, nonatomic) IBOutlet UITextField *txtfQuantity;
@property (strong, nonatomic) IBOutlet UITableView *tblvOrderiteamData;
@property (strong, nonatomic) IBOutlet UILabel     *lblQnty;

@property (strong, nonatomic) NSMutableArray *arrSelectedParts;
@property (strong, nonatomic) ACEParts *selectedPart;

@property float totalAmount;
@property ZWTTextboxToolbarHandler *handler;

@end

@implementation AddNewOrderViewController

@synthesize txtfselectItem,txtfQuantity,tblvOrderiteamData,arrSelectedParts,selectedPart,handler,totalAmount,lblTotal,lblQnty;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrSelectedParts = [[NSMutableArray alloc]init];
    //selectedPart = [[ACEOrderIteam alloc]init];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:txtfQuantity, nil] andScroll:nil];
    handler.delegate         = self;
    handler.showNextPrevious = NO;
    
    totalAmount   = 0;
    lblTotal.text = [NSString stringWithFormat:@"$%.02f",totalAmount];
}
-(BOOL)isValidDetail
{
    if([txtfselectItem.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"Please choose part"];
        return NO;
    }
    else if ([txtfQuantity.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"Please enter quantity"];
        return NO;
    }
    else if (![txtfQuantity.text isEqualToString:@""])
    {
        int qty = [txtfQuantity.text intValue];
        
        if(qty <=0 )
        {
            [self showAlertWithMessage:ACEInvalidQty];
             return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddIteamTap:(id)sender
{
    
    if([self isValidDetail])
    {
        //selectedOrder.Qnty  = @([[NSString stringWithFormat:@"%@",txtfQuantity.text]integerValue]);
        //selectedOrder.Price = [NSNumber numberWithFloat:50.00];
        NSDictionary *partDict = @{
                                   OIKeyPart  : selectedPart,
                                   OIKeyQunty : txtfQuantity.text
                                  };
        
        totalAmount  += (selectedPart.partPrice * [txtfQuantity.text floatValue]);
        lblTotal.text = [NSString stringWithFormat:@"$%.02f",totalAmount];

        [arrSelectedParts addObject:partDict];
        
       // NSLog(@"%@",selectedPart);
        
        [tblvOrderiteamData reloadData];
        [txtfQuantity resignFirstResponder];
        txtfselectItem.text         = @"";
        txtfQuantity.text           = @"";
        //selectedPart                = [[ACEParts alloc]init];
        //selectedOrder               = [[ACEOrderIteam alloc]init];
    }
    
    
}
- (IBAction)btnDeleteCellTap:(UIButton *)sender
{
    CGPoint center        = sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:tblvOrderiteamData];
    
    NSIndexPath *indexPath = [tblvOrderiteamData indexPathForRowAtPoint:rootViewPoint];
    NSDictionary *dict     = arrSelectedParts[indexPath.section];
    
    [arrSelectedParts removeObjectAtIndex:indexPath.section];
    
    [tblvOrderiteamData reloadData];
    
    //[tblvOrderiteamData deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
    float price = ([dict[OIKeyQunty] floatValue] * [dict[OIKeyPart] partPrice]);
    
    totalAmount  -= price;
    lblTotal.text = [NSString stringWithFormat:@"$%.02f",fabsf(totalAmount)];
}
- (IBAction)btnCheckoutTap:(id)sender
{
    if(arrSelectedParts.count > 0)
    {
        AddOrderClientInfoViewController *avc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddOrderClientInfoViewController"];
        avc.totalAmount  = totalAmount;
        avc.selectedItem = arrSelectedParts;
        // NSLog(@"%@",self.navigationController);
        [self.navigationController pushViewController:avc animated:YES];
    }
    else
    {
        [self showAlertWithMessage:@"Please add parts first"];
    }
}

- (IBAction)btnSearchItemTap:(id)sender
{
    SearchPartViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPartViewController"];
    
    svc.delegate       = self;
    svc.isFromAddOrder = YES;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - tableview data source and delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrSelectedParts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = arrSelectedParts[indexPath.section];
    
    ACEAddNewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACEAddNewOrderCell"];
    cell.lblQnty.text        = dict[OIKeyQunty];
    
    cell.lblPartName.text    = [NSString stringWithFormat:@"%@ %@",
    [dict[OIKeyPart] partName] , [dict[OIKeyPart] partSize]];
    
    float price              = ([dict[OIKeyQunty] floatValue] * [dict[OIKeyPart] partPrice]);
                                
    cell.lblPrice.text       = [NSString stringWithFormat:@"$%.02f",price];
    cell.lblIndex.text       = [NSString stringWithFormat:@"%ld",(long)indexPath.section + 1];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    
    //[cell setCellData:selectedParts[indexPath.section]];
    
    return cell;
}
#pragma mark - UITextField Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtfQuantity)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 2)
        {
            return NO;
        }
        return YES;
        
    }
    return YES;
}
#pragma mark - SearchPart delegate method
-(void)SelectedPartName:(ACEParts *)part
{
    txtfselectItem.text = [NSString stringWithFormat:@"%@ %@",
    part.partName, part.partSize];
    selectedPart = part;
    
    if([selectedPart.partMasterId isEqualToString:@"4"])
    {
        lblQnty.text = @"Quantity (lbs)";
    }
    else
    {
        lblQnty.text = @"Quantity";
    }
    //selectedOrder.Name = partname;
    //[selectedParts addObject:part];
    //[tblvOrderiteamData reloadData];
}
#pragma mark - ZWTTextboxToolbarHandlerDelegate Method
-(void)doneTap
{
}

@end
