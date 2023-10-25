//
//  Callback.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/16.
//

import Foundation

public typealias Action = () -> Void
public typealias Action1<T> = (_ arg: T) -> Void
public typealias Action2<T1, T2> = (_ arg1: T1, _ arg2: T2) -> Void
public typealias Action3<T1, T2, T3> = (_ arg1: T1, _ arg2: T2, _ arg3: T3) -> Void


public typealias ActionReturn<TResult> = () -> TResult
public typealias ActionReturn1<T, TResult> = (_ arg: T) -> TResult
public typealias ActionReturn2<T1, T2, TResult> = (_ arg1: T1, _ arg2: T2) -> TResult
public typealias ActionReturn3<T1, T2, T3, TResult> = (_ arg1: T1, _ arg2: T2, _ arg3: T3) -> TResult
