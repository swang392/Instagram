//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Sarah Wang on 7/7/21.
//

#import "PostDetailsViewController.h"
#import "Post.h"
#import "DateTools.h"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
}

- (void)refreshData {
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];

    self.postCaptionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.createdAtLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
}
- (IBAction)likeButtonTapped:(id)sender {
    //will do this later. right now its just for style
}
- (IBAction)commentButtonTapped:(id)sender {
    //will do this later. right now its just for style
}
@end
