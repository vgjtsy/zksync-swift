//
//  ZkSigner.swift
//  ZKSyncSDK
//
//  Created by Eugene Belyakov on 11/01/2021.
//

import Foundation
import CryptoSwift

enum ZkSignerError: Error {
    case invalidPrivateKey
    case incorrectDataLength
    case invalidSignatureType(EthSignature.SignatureType)
}

class ZkSigner {
    
    private static let Message = "Access zkSync account.\n\nOnly sign this message for a trusted client!"
    
    let privateKey: ZKPrivateKey
    let publicKey: ZKPackedPublicKey
    let publicKeyHash: ZKPublicHash
    
    init(privateKey: ZKPrivateKey) throws {
        self.privateKey = privateKey
        
        switch ZKCryptoSDK.getPublicKey(privateKey: privateKey) {
        case .success(let key):
            self.publicKey = key
        default:
            throw ZkSignerError.invalidPrivateKey
        }
        
        switch ZKCryptoSDK.getPublicKeyHash(publicKey: self.publicKey) {
        case .success(let hash):
            self.publicKeyHash = hash
        default:
            throw ZkSignerError.invalidPrivateKey
        }
    }
    
    convenience init(seed: Data) throws {
        switch ZKCryptoSDK.generatePrivateKey(seed: seed) {
        case .success(let privateKey):
            try self.init(privateKey: privateKey)
        case .error(let error):
            throw error
        }
    }
    
    convenience init(rawPrivateKey: Data) throws {
        if rawPrivateKey.count != ZKPrivateKey.bytesLength {
            throw ZkSignerError.incorrectDataLength
        }
        try self.init(privateKey: ZKPrivateKey(rawPrivateKey))
    }
    
    convenience init(ethSigner: EthSigner, chainId: ChainId) throws {
        var message = ZkSigner.Message
        if chainId != .mainnet {
            message = "\(message)\nChain ID: \(chainId.id)."
        }
        let signature = try ethSigner.sign(message: message)
        
        if signature.type != .ethereumSignature {
            throw ZkSignerError.invalidSignatureType(signature.type)
        }
        
        try self.init(seed: Data(hex: signature.signature))
    }
}