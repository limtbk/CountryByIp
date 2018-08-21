//
//  CountryByIP.h
//  iptocountry
//
//  Created by Ivan Klymchuk on 2018-08-21.
//

#import <Foundation/Foundation.h>

@interface CountryByIP : NSObject

- (NSString *)countryFromIPv4:(NSArray *)ipv4addr;
- (NSString *)countryFromIPv6:(NSArray *)ipv6addr;

@end
