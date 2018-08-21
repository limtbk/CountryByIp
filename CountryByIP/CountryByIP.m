//
//  CountryByIP.m
//  iptocountry
//
//  Created by Ivan Klymchuk on 2018-08-21.
//

#import "CountryByIP.h"

typedef struct __attribute__((__packed__)) {
    uint8_t addr[4];
    uint8_t code[2];
} ipv4pck;

typedef struct __attribute__((__packed__)) {
    uint16_t addr[8];
    uint8_t code[2];
} ipv6pck;

BOOL ge4(ipv4pck a, ipv4pck b) {
    for (int i = 0; i < 4; i++) {
        if (a.addr[i]>b.addr[i]) {
            return YES;
        } else if (a.addr[i]<b.addr[i]) {
            return NO;
        } else {
            continue;
        }
    }
    return YES;
}

BOOL l4(ipv4pck a, ipv4pck b) {
    for (int i = 0; i < 4; i++) {
        if (a.addr[i]>b.addr[i]) {
            return NO;
        } else if (a.addr[i]<b.addr[i]) {
            return YES;
        } else {
            continue;
        }
    }
    return NO;
}

BOOL ge6(ipv6pck a, ipv6pck b) {
    for (int i = 0; i < 8; i++) {
        if (a.addr[i]>b.addr[i]) {
            return YES;
        } else if (a.addr[i]<b.addr[i]) {
            return NO;
        } else {
            continue;
        }
    }
    return YES;
}

BOOL l6(ipv6pck a, ipv6pck b) {
    for (int i = 0; i < 8; i++) {
        if (a.addr[i]>b.addr[i]) {
            return NO;
        } else if (a.addr[i]<b.addr[i]) {
            return YES;
        } else {
            continue;
        }
    }
    return NO;
}

@interface CountryByIP()

@property (strong) NSData *ipv4data;
@property (strong) NSData *ipv6data;

@end

@implementation CountryByIP

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ipv4data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ipv4" ofType:@"dat"]];
        self.ipv6data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ipv6" ofType:@"dat"]];
    }
    return self;
}

- (NSString *)countryFromIPv4:(NSArray *)ipv4addr {
    ipv4pck addr = {[ipv4addr[0] integerValue],[ipv4addr[1] integerValue],[ipv4addr[2] integerValue],[ipv4addr[3] integerValue], 0, 0};
    ipv4pck *ipv4data = (ipv4pck *)[self.ipv4data bytes];
    int length = (int)([self.ipv4data length] / sizeof(ipv4pck));
    int left = 0;
    int right = length;
    int i = left + (right - left) / 2;
    while ((i < length - 1) && !(ge4(addr, ipv4data[i]) && l4(addr, ipv4data[i + 1])) && (left < right)) {
        if (l4(addr, ipv4data[i])) {
            right = i;
            i = left + (right - left) / 2;
        } else if (ge4(addr, ipv4data[i+1])) {
            left = i + 1;
            i = left + (right - left) / 2;
        } else {
            break;
        }
    }
    if (left >= right) {
        i = length - 1;
    }
    char r[3] = {ipv4data[i].code[0], ipv4data[i].code[1], 0};
    NSString *result = [NSString stringWithUTF8String:r];
    return result;
}

- (NSString *)countryFromIPv6:(NSArray *)ipv6addr {
    ipv6pck addr = {[ipv6addr[0] integerValue], [ipv6addr[1] integerValue], [ipv6addr[2] integerValue], [ipv6addr[3] integerValue], [ipv6addr[4] integerValue], [ipv6addr[5] integerValue], [ipv6addr[6] integerValue], [ipv6addr[7] integerValue], 0, 0};
    ipv6pck *ipv6data = (ipv6pck *)[self.ipv6data bytes];
    int length = (int)([self.ipv6data length] / sizeof(ipv6pck));
    int left = 0;
    int right = length;
    int i = left + (right - left) / 2;
    while ((i < length - 1) && !(ge6(addr, ipv6data[i]) && l6(addr, ipv6data[i + 1])) && (left < right)) {
        if (l6(addr, ipv6data[i])) {
            right = i;
            i = left + (right - left) / 2;
        } else if (ge6(addr, ipv6data[i+1])) {
            left = i + 1;
            i = left + (right - left) / 2;
        } else {
            break;
        }
    }
    if (left >= right) {
        i = length - 1;
    }
    char r[3] = {ipv6data[i].code[0], ipv6data[i].code[1], 0};
    NSString *result = [NSString stringWithUTF8String:r];
    return result;
}


@end
