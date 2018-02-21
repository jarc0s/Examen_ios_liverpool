//
//  HistoricalViewController.m
//  Examen Livepool Juan Arcos
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import "HistoricalViewController.h"

@interface HistoricalViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrayDataHistorical;
    NSUserDefaults *defaults;
}

@end

@implementation HistoricalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    arrayDataHistorical = [[NSArray alloc] initWithArray:[defaults objectForKey:@"historicalData"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideView:(UITapGestureRecognizer *)sender {
    [self.view removeFromSuperview];
}

-(void)reloadData{
    arrayDataHistorical = nil;
    arrayDataHistorical = [[NSArray alloc] initWithArray:[defaults objectForKey:@"historicalData"]];
    [historicalTable reloadData];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tipoCelda = @"cellLabelHistorical";
    
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
    return arrayDataHistorical.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height * 0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    UILabel *_lblTitulo = [cell viewWithTag:100];
    [_lblTitulo setText:[arrayDataHistorical objectAtIndex:indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate valorSeleccionado:[arrayDataHistorical objectAtIndex:indexPath.row]];
}

@end
