//
//  MoviesViewController.m
//  tomatoes
//
//  Created by Venkadeshkumar Dhandapani on 1/19/14.
//  Copyright (c) 2014 Venkadeshkumar Dhandapani. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieViewController.h"
#import "MovieCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) NSMutableArray *movies;

@end

@implementation MoviesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.movies = [[NSMutableArray alloc] init];
        [self loadMovies];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.movies = [[NSMutableArray alloc] init];
        [self loadMovies];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.movies = [[NSMutableArray alloc] init];
    [self loadMovies];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table View Methods

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    cell.castLabel.text =movie.cast;
    NSString *thumbnailImgURL = movie.posterURL;
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:thumbnailImgURL]]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                   }];
    return cell;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    MovieViewController *movieViewController = (MovieViewController *)[segue destinationViewController];
    
    Movie *movie = self.movies[indexPath.row];
    
    movieViewController.movieItem = movie;
}

# pragma mark - Private Methods

- (void)refreshView:(UIRefreshControl *)sender {
    [self loadMovies];
    [sender endRefreshing];
}

-(void) loadMovies{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Manager = %@", manager);
             
             //AFHTTPRequestOperationManager *m = manager;
             //self.errorLabel.text = @"";
             self.errorLabel.hidden = YES;
             NSDictionary *movieDictionary = (NSDictionary *)responseObject;
             [self createMovieModel : [movieDictionary objectForKey:@"movies"]];
             [self.tableView reloadData];
             
             NSLog(@"MovieDictionary = %@", movieDictionary);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.errorLabel.text = error.localizedDescription;
             self.errorLabel.hidden = NO;
         }];
}

-(void)createMovieModel:(NSArray *)movieArray{
    for(NSDictionary *movieDictionary in movieArray){
        Movie *movie = [[Movie alloc] init];
        movie.title = [movieDictionary objectForKey:@"title"];
        movie.synopsis = [movieDictionary objectForKey:@"synopsis"];
        NSArray *castArray = [movieDictionary valueForKeyPath:@"abridged_cast.name"];
        movie.cast =(NSString *) [castArray componentsJoinedByString:@","];
        movie.posterURL  = [movieDictionary valueForKeyPath:@"posters.profile"];
        
        [self.movies addObject:movie];
    }
}
@end
