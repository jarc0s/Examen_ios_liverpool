//
//  WebServices.h
//  AstroWeb
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestOperationDTO.h"

@interface WebServices : NSObject

{
    void (^_callbackHandler)(RequestOperationDTO *requestOperationDTO);
}

@property (nonatomic) id delegate;

+(void) ResponseData : (NSString *) url
            complete : (void (^)(RequestOperationDTO *))handler;

+(void) ResponseDataFile : (NSString *) url
            complete : (void (^)(RequestOperationDTO *))handler;

+(void) ResponseDataPost : (NSString *)url
          withParameters : (NSDictionary *)params
                complete : (void (^)(RequestOperationDTO *))handler;



@end
