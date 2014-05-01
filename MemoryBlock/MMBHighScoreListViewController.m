#import "MMBHighScoreListViewController.h"
#import "MMBColorUtility.h"
#import "MMBScoreView.h"
#import "MMBAppDelegate.h"
#import "MMBScoreViewCell.h"
#import "HighScore.h"

static NSString* const MMBCellIdentifier = @"MMBCellScoreView";

@interface MMBHighScoreListViewController ()

@property (strong, nonatomic) NSMutableArray *highScoreArray;

@end

@implementation MMBHighScoreListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"MMBHighScoreListViewController" bundle:nil];
    if (self) {
        self.navigationItem.title = @"High Score";
        _highScoreArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UICOLOR_HEX(0xE6D8CC)];
    
    // Set up table view
    UINib *nib = [UINib nibWithNibName:@"MMBScoreViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:MMBCellIdentifier];
    
    // Retrieve data
    MMBAppDelegate *app = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = app.managedObjectContext;
    self.highScoreArray = [[app fetchAllHighScore] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_highScoreArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMBScoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMBCellIdentifier forIndexPath:indexPath];
    HighScore *highScore = _highScoreArray[indexPath.row];
    [cell.labelScore setText:[highScore.score stringValue]];
    [cell.labelDate setText:[self readableTimeStamp:highScore.date]];
    return cell;
}

- (NSString *)readableTimeStamp:(NSString *)dateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *component = [calendar components:flags fromDate:date toDate:now options:0];
    int year = (int)[component year];
    int month = (int)[component month];
    int day = (int)[component day];
    int hour = (int)[component hour];
    int minute = (int)[component minute];
    if (year > 0) {
        return [NSString stringWithFormat:@"%d years ago", year];
    }
    if (month > 0) {
        return [NSString stringWithFormat:@"%d months ago", month];
    }
    if (day > 0) {
        return [NSString stringWithFormat:@"%d days ago", day];
    }
    if (hour > 0) {
        return [NSString stringWithFormat:@"%d hours ago", hour];
    }
    if (minute > 0) {
        return [NSString stringWithFormat:@"%d minutes ago", minute];
    }
    return [NSString stringWithFormat:@"just now"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
