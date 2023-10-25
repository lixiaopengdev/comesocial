//
//  RetryWorkItem.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/30.
//

import Foundation
import Combine

class RetryWorkItem {
    private var timer: Timer?
    let onReconnect = PassthroughSubject<(), Never>()
    private var retryTicket = 4
    private var retryTicketBase = 4
    
    func open() {
        print("==========\(#function)")

        reset()
        self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.retryTicket -= 1
            if self.retryTicket <= 0 {
                self.reconnect()
            }
        })
    }
    
    private func reconnect() {
        retryTicketBase = retryTicketBase * 2
        retryTicket = retryTicketBase
        onReconnect.send(())
    }
    
    func close() {
        print("==========\(#function)")
        reset()

    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        retryTicket = 4
        retryTicketBase = 4
    }
    
}
