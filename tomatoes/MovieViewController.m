//
//  MovieViewController.m
//  tomatoes
//
//  Created by Venkadeshkumar Dhandapani on 1/19/14.
//  Copyright (c) 2014 Venkadeshkumar Dhandapani. All rights reserved.
//

#import "MovieViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *cast;
@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	Movie *movie = self.movieItem;
    
    self.title = movie.title;
    self.synopsis.text = movie.synopsis;
    self.cast.text =movie.cast;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.imageView.center;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:movie.posterURL]];

    [self.imageView setImageWithURLRequest:request
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  [activityIndicatorView removeFromSuperview];
                                  self.imageView.image = image;
                              }
                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  [activityIndicatorView removeFromSuperview];
                              
                              }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
