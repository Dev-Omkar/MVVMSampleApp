//
//  RechabilityManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation
class RechabilityManager{
    static var shared = RechabilityManager.init()
    var isReachable = false
    let reachability = try! Reachability()
    
    func listen(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.isReachable = true
            } else {
                self.isReachable = true
            }
        }
        reachability.whenUnreachable = { _ in
            self.isReachable = false
        }
    }
    func startNotify(){
        do {
            listen()
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stop(){
        reachability.stopNotifier()
        
    }
    
    
}
