//
//  HomeViewController.m
//  Instagram
//
//  Created by Sarah Wang on 7/6/21.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "PostCell.h"
#import "PostDetailsViewController.h"
@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL morePostsLoading;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self queryPosts:20];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = controller;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.post = self.posts[indexPath.row];
    [cell refreshData];
    return cell;
}

- (void) queryPosts:(int) numPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = numPosts;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            [self.tableView reloadData];
            self.morePostsLoading = false;
        } else {
            //TODO: show error
        }
    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self queryPosts:20];
    [refreshControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.morePostsLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int loadingThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;

        if(scrollView.contentOffset.y > loadingThreshold && self.tableView.isDragging) {
            self.morePostsLoading = true;
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError * _Nullable error) {
                if (!error) {
                    if (count > self.posts.count) {
                        [self queryPosts:(self.posts.count+20)];
                    }
                }
            }];

        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = self.posts[indexPath.row];
    }
}

@end
