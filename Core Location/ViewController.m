//
//  ViewController.m
//  Core Location
//
//  Created by Larry Feldman on 5/22/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *address;
- (IBAction)buttonPressed:(id)sender;

@end

@implementation ViewController {
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [manager requestAlwaysAuthorization];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Error: %@", error);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if ([locations lastObject] != nil) {
        
        CLLocation *lastLocation = [locations lastObject];

        self.latitude.text = [NSString stringWithFormat:@"%.8f", lastLocation.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%.8f", lastLocation.coordinate.longitude];

    //    NSLog(@"%@", [locations lastObject]);
        
        [geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error == nil && [placemarks count] > 0) {
                
                placemark = [placemarks lastObject];
                
                self.address.text = [NSString stringWithFormat:@"%@ %@\n%@, %@ %@\n%@",
                                     placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.locality, placemark.administrativeArea, placemark.postalCode,                                                                    
                                     placemark.country];
            } else {
                
                NSLog(@"%@", error.debugDescription);
            }
            
        }];
        
    }
}






@end
