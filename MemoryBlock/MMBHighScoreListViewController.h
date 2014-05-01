//
//  MMBHighScoreListViewController.h
//  MemoryBlock
//
//  Created by chan on 4/29/14.
//  Copyright (c) 2014 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBHighScoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
