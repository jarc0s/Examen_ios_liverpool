//
//  ViewController.m
//  Examen Livepool Juan Arcos
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import "ViewController.h"
#import "WebServices.h"

#define _URL_MASTER @"https://www.liverpool.com.mx/tienda?s=%@&d3106047a194921c01969dfdec083925=json"

@interface ViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *arrayData;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayData = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tipoCelda = @"cellProducto";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipoCelda];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tipoCelda];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height * 0.12;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *_imgView = [cell viewWithTag:100];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       //
                       //product.smallImage
                       NSURL *imageURL = [NSURL URLWithString:[[[[arrayData objectAtIndex:indexPath.row] objectForKey:@"attributes"] valueForKey:@"sku.thumbnailImage"] objectAtIndex:0]];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           _imgView.image = [UIImage imageWithData:imageData];
                           
                       });
                   });
    
    UILabel *_lblTitulo = [cell viewWithTag:200];
    [_lblTitulo setText:[[[[arrayData objectAtIndex:indexPath.row] objectForKey:@"attributes"] valueForKey:@"product.displayName"] objectAtIndex:0]];
    
    UILabel *_lblPrecio = [cell viewWithTag:210];
    //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_lblPrecio setText:[NSString localizedStringWithFormat:@"$ %.2f",[[[[[arrayData objectAtIndex:indexPath.row] objectForKey:@"attributes"] valueForKey:@"sku.sale_Price"] objectAtIndex:0] floatValue]]];
    
    UILabel *_lblUbicacion = [cell viewWithTag:220];
    [_lblUbicacion setText:[[[[arrayData objectAtIndex:indexPath.row] objectForKey:@"attributes"] valueForKey:@"product.brand"] objectAtIndex:0]];
    
}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //Buscar producto
    [textField endEditing:YES];
    NSString *_url = [NSString stringWithFormat:_URL_MASTER,textField.text ];
    [WebServices ResponseData:[_url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding] complete:^(RequestOperationDTO *response) {
        NSLog(@"succes: %d", response.success);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *_mainContentD;
            for (NSDictionary *_dicMainC in [[[response.listaData valueForKey:@"contents"] objectAtIndex:0] objectForKey:@"mainContent"]) {
                if([[_dicMainC valueForKey:@"name"] isEqualToString:@"Results List Collection"]){
                    _mainContentD = [[NSDictionary alloc] initWithDictionary:_dicMainC];
                    break;
                }
            }
            [arrayData removeAllObjects];
            arrayData = nil;
            arrayData = [[NSMutableArray alloc] initWithArray:[[[_mainContentD objectForKey:@"contents"] objectAtIndex:0] objectForKey:@"records"]];
            [dataTableView setContentOffset:CGPointZero animated:YES];
            [dataTableView reloadData];
        });
        
    }];
    return YES;
}

@end
