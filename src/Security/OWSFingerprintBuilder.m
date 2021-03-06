//  Created by Michael Kirk on 9/22/16.
//  Copyright © 2016 Open Whisper Systems. All rights reserved.

#import "OWSFingerprintBuilder.h"
#import "ContactsManagerProtocol.h"
#import "OWSFingerprint.h"
#import "TSStorageManager+IdentityKeyStore.h"
#import "TSStorageManager+keyingMaterial.h"
#import <Curve25519/Curve25519.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSFingerprintBuilder ()

@property (nonatomic, readonly) TSStorageManager *storageManager;
@property (nonatomic, readonly) id<ContactsManagerProtocol> contactsManager;

@end

@implementation OWSFingerprintBuilder

- (instancetype)initWithStorageManager:(TSStorageManager *)storageManager
                       contactsManager:(id<ContactsManagerProtocol>)contactsManager
{
    self = [super init];
    if (!self) {
        return self;
    }

    _storageManager = storageManager;
    _contactsManager = contactsManager;

    return self;
}

- (OWSFingerprint *)fingerprintWithTheirSignalId:(NSString *)theirSignalId
{
    NSData *_Nullable theirIdentityKey = [self.storageManager identityKeyForRecipientId:theirSignalId];

    return [self fingerprintWithTheirSignalId:theirSignalId theirIdentityKey:theirIdentityKey];
}

- (OWSFingerprint *)fingerprintWithTheirSignalId:(NSString *)theirSignalId theirIdentityKey:(NSData *)theirIdentityKey
{
    NSString *theirName = [self.contactsManager nameStringForPhoneIdentifier:theirSignalId];

    NSString *mySignalId = [self.storageManager localNumber];
    NSData *myIdentityKey = [self.storageManager identityKeyPair].publicKey;

    return [OWSFingerprint fingerprintWithMyStableId:mySignalId
                                       myIdentityKey:myIdentityKey
                                       theirStableId:theirSignalId
                                    theirIdentityKey:theirIdentityKey
                                           theirName:theirName];
}

@end

NS_ASSUME_NONNULL_END
