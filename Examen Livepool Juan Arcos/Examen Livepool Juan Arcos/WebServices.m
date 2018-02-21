//
//  WebServices.m
//  AstroWeb
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import "WebServices.h"
#import "AppDelegate.h"

@implementation WebServices

+(void)ResponseData:(NSString *)url complete:(void (^)(RequestOperationDTO *))handler{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    RequestOperationDTO *resultado = [[RequestOperationDTO alloc] init];
                                                    NSLog(@"Peticion Realizada");
                                                    if (error) {
                                                        [resultado setSuccess : NO];
                                                        [resultado setMessageError:@"Servicio no disponible"];
                                                        
                                                    }else {
                                                        NSDictionary *dictionaryHeaders;
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                        if ([response respondsToSelector:@selector(allHeaderFields)]) {
                                                            dictionaryHeaders = [httpResponse allHeaderFields];
                                                            NSLog(@"statusCode :%ld", (long)[httpResponse statusCode]);
                                                        }
                                                        
                                                        NSLog(@"Content-Type: %@",dictionaryHeaders);
                                                        NSLog(@"Peticion Realizada");
                                                        
                                                        if (error || [[dictionaryHeaders valueForKey:@"Content-Type"] rangeOfString:@"text/html"].location != NSNotFound) {
                                                            
                                                            [resultado setSuccess : NO];
                                                            [resultado setMessageError:@"Servicio no disponible"];
                                                        }else {
                                                            NSError *myError;
                                                            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                            NSLog(@"error :: %@", myError);
                                                            //NSLog(@"JSON :  %@", json);
                                                            if (json == NULL) {
                                                                NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
                                                                [resultado setSuccess : NO];
                                                                [resultado setMessageError : @"Servicio no disponible"];
                                                            } else {
                                                                [resultado setSuccess: YES];
                                                                [resultado setListaData:json];
                                                            }
                                                        }
                                                    }
                                                    
                                                    handler(resultado);
                                                }];
    [dataTask resume];
}

+(void)ResponseDataFile:(NSString *)url complete:(void (^)(RequestOperationDTO *))handler{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    RequestOperationDTO *resultado = [[RequestOperationDTO alloc] init];
                                                    NSLog(@"Peticion Realizada");
                                                    if (error) {
                                                        [resultado setSuccess : FALSE];
                                                        if([error.localizedDescription rangeOfString:@"offline"].location != NSNotFound){
                                                            [resultado setMessageError:@""];
                                                        }else{
                                                            [resultado setMessageError:@""];
                                                        }
                                                        
                                                    }else {
                                                        NSDictionary *dictionaryHeaders;
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                        if ([response respondsToSelector:@selector(allHeaderFields)]) {
                                                            dictionaryHeaders = [httpResponse allHeaderFields];
                                                            NSLog(@"statusCode :%ld", (long)[httpResponse statusCode]);
                                                        }
                                                        
                                                        NSLog(@"Content-Type: %@",dictionaryHeaders);
                                                        NSLog(@"Peticion Realizada");
                                                        
                                                        if (error || [[dictionaryHeaders valueForKey:@"Content-Type"] rangeOfString:@"audio/mp3"].location == NSNotFound) {
                                                            NSLog(@"%@", error);
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"error :: %@", httpResponse);
                                                        }else{
                                                            resultado.success = YES;
                                                            resultado.listaData = data;
                                                        }
                                                        
                                                    }
                                                    handler(resultado);
                                                }];
    [dataTask resume];
}

+(void) ResponseDataPost : (NSString *)url
          withParameters : (NSDictionary *)params
                complete : (void (^)(RequestOperationDTO *))handler{
    
    NSDictionary *headers = @{ @"content-type": @"application/json"};
    
    NSLog(@"url: %@", url);
    NSLog(@"params: %@", params);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject : params
                                                       options : 0
                                                         error : nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    
    /*NSString *str = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"str: %@", str);*/
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    RequestOperationDTO *resultado = [[RequestOperationDTO alloc] init];
                                                    NSLog(@"Peticion Realizada");
                                                    resultado.messageError = url;
                                                    resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"%@",params]];
                                                    //resultado.messageError = [resultado.messageError stringByAppendingString:appDelegateTemp.logInfoSteps];
                                                    
                                                    if (error) {
                                                        
                                                        NSLog(@"error: %@", [error userInfo]);
                                                        
                                                        
                                                        resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nNSURLResponse - ERROR - NSLocalizedDescription: %@",[[error userInfo] valueForKey:@"NSLocalizedDescription"]]];
                                                        resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nRESPONSE: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                                                        [resultado setSuccess : FALSE];
                                                        if([error.localizedDescription rangeOfString:@"offline"].location != NSNotFound){
                                                            //[resultado setMessageError:_NSERROR_10002];
                                                            resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\_NSERROR_10002: %@",@""]];
                                                            
                                                        }else{
                                                            //[resultado setMessageError:_NSERROR_10001];
                                                            resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\_NSERROR_10001: %@",@""]];
                                                            
                                                        }
                                                        
                                                    }else{
                                                        NSDictionary *dictionaryHeaders;
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                        if ([response respondsToSelector:@selector(allHeaderFields)]) {
                                                            dictionaryHeaders = [httpResponse allHeaderFields];
                                                        }
                                                        
                                                        
                                                        NSLog(@"Content-Type: %@",[dictionaryHeaders valueForKey:@"Content-Type"]);
                                                        NSLog(@"Peticion Realizada");
                                                        
                                                        resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nDictionaryHeaders: %@",dictionaryHeaders]];
                                                        
                                                        
                                                        if (error || [[dictionaryHeaders valueForKey:@"Content-Type"] rangeOfString:@"text/html"].location != NSNotFound) {
                                                            NSLog(@"%@*******", error);
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"error :: %@", httpResponse);
                                                            //resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nhttpResponse : %@",httpResponse]];
                                                            resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nRESPONSE: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                                                        }else{
                                                            NSError *myError;
                                                            NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                            resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nRESPONSE: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                                                            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&myError];
                                                            resultado.messageError = [resultado.messageError stringByAppendingString:[NSString stringWithFormat:@"\nJSON NSJSONSerialization: %@",myError]];
                                                            
                                                            NSLog(@"error :: %@", myError);
                                                            NSLog(@"JSON :  %@", json);
                                                            if (json == NULL) {
                                                                NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
                                                                [resultado setSuccess : FALSE];
                                                                [resultado setMessageError : @""];
                                                            } else {
                                                                [resultado setSuccess: [[json valueForKey:@"success"] intValue]];
                                                                [resultado setListaData:json];
                                                            }
                                                        }
                                                    }
                                                    
                                                    handler(resultado);
                                                }];
    [dataTask resume];
}

@end
