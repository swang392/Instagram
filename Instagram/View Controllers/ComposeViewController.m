//
//  ComposeViewController.m
//  Instagram
//
//  Created by Sarah Wang on 7/7/21.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *composeImageView;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeImageView.image = nil;
    self.composeTextView.text = @"";
    
    self.composeTextView.delegate = self;
    self.composeTextView.layer.borderWidth = 2.0f;
    self.composeTextView.layer.borderColor = [[UIColor systemGrayColor] CGColor];
    self.composeTextView.layer.cornerRadius = 8;
    
    [self takePhoto:YES];
}

- (void) takePhoto:(BOOL)canTakePhoto {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if(canTakePhoto){
        //TODO: add option if cantakePhoto
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
        }
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
   //method from codepath
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    CGSize newSize = CGSizeMake(20, 20);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:newSize];
   
    [self.composeImageView setImage:editedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onShare:(id)sender {
    UIImage *imageToPost = self.composeImageView.image;
    NSString *captionToPost = self.composeTextView.text;

    [Post postUserImage:imageToPost withCaption:captionToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"posted image successfuly");
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            NSLog(@"Error posting: %@", error.localizedDescription);
        }
    }];;
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
