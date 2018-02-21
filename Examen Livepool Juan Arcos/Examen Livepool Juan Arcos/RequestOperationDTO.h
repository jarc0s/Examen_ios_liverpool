//
//  RequestOperationDTO.h
//  jarcos.cripto
//
//  Created by Juan on 20/02/18.
//  Copyright © 2018 Juan Arcos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestOperationDTO : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic, retain) id listaData;
@property (nonatomic, retain) NSString *messageError;

@end
