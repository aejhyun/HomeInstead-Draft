//
//  OverloadedOperators.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/3/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import Foundation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}