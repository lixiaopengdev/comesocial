//
//  Heartbeat.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/30.
//

import Foundation
import Combine

class Heartbeat {
    
    private var timer: Timer?
    private var pingCount = 0;
    private var pingTicket = 8
    
    let onSendPing = PassthroughSubject<(), Never>()
    @Published var isDied = false
    
    func open() {
        print("==========Heartbeat\(#function)")
        timer?.invalidate()
        timer = nil
        reset()
        self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.pingTicket -= 1
            if self.pingTicket <= 0 {
                self.sendPing()
            }
        })
    }
    
    func close() {
        print("==========Heartbeat\(#function)")
        timer?.invalidate()
        timer = nil
        reset()
    }
    
    func receivePong() {
//        printLog("==== receivePong.......")
        DispatchQueue.main.async {
            self.reset()
        }
    }
    
    private func reset() {
        pingCount = 0
        pingTicket = 8
        setDied(false)
    }
    
    private func setDied(_ died: Bool) {
        if isDied != died {
            isDied = died
        }
    }
    
    private func sendPing() {
        pingCount += 1
        pingTicket = 8
        if pingCount >= 3 {
            setDied(true)
            return
        }
        onSendPing.send(())
    }
    
    deinit {
        close()
    }
}
