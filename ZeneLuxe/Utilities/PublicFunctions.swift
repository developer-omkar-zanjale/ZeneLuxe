//
//  PublicFunctions.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import Foundation

func printLog(_ str: String) {
    print(str)
}

func asyncQueue(completion: @escaping(()->())) {
    DispatchQueue.main.async {
        completion()
    }
    
    
}

func asyncAfter(_ delay: Double = 2, completion: @escaping(()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
        completion()
    })
}
