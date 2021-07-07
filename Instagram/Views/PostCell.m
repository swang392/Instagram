//
//  PostCell.m
//  Instagram
//
//  Created by Sarah Wang on 7/7/21.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData{
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];

    self.postCaptionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
}
@end
