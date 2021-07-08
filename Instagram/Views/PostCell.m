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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData{
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];

    self.postCaptionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
}
@end
