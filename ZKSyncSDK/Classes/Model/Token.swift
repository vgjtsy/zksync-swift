//
//  Token.swift
//  ZKSyncSDK
//
//  Created by Eugene Belyakov on 06/01/2021.
//

import Foundation
import BigInt
import web3swift

public struct Token {
    
    let id: Int
    public let address: String
    let symbol: String
    let decimals: Int
    
    public static var ETH: Token {
        return Token(id: 0,
                     address: "0x0000000000000000000000000000000000000000",
                     symbol: "ETH",
                     decimals: 0)
    }
    
//    func intoDecimal(amount: BigInt) -> Decimal {
//        Decimal(amount)
//    }
    
//    public BigDecimal intoDecimal(BigInteger amount) {
//            return new BigDecimal(amount)
//                .setScale(decimals)
//                .divide(BigDecimal.TEN.pow(decimals), RoundingMode.DOWN);
//        }
}
