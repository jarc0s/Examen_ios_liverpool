//
//  HistoricalViewController.h
//  Examen Livepool Juan Arcos
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoricalViewControllerDelegate <NSObject>

@required
-(void)valorSeleccionado:(NSString *)campoSeleccionado;

@end

@interface HistoricalViewController : UIViewController{
    
    __weak IBOutlet UITableView *historicalTable;
}

@property (nonatomic, strong) id<HistoricalViewControllerDelegate> delegate;

- (IBAction)hideView:(UITapGestureRecognizer *)sender;
-(void)reloadData;

@end
