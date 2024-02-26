//
//  SocketIOManager.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import Foundation
import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    private init() { }
    
    private let manager = SocketManager(socketURL: URL(string: Configurations.baseURL)!,
                                               config: [.log(true), .compress])
    private var socket: SocketIOClient?
    private var timer: Timer?
    
    func open(id channelID: Int, completion: @escaping (ChannelChatResponseDTO) -> ()) {
        print(#function, "소켓 열어요~")
        
        socket = manager.socket(forNamespace: "/ws-channel-\(channelID)")
        addEventHandler()
        socket?.connect()
        
        receive(completion: completion)
        
        ping()
    }
    
    func close() {
        print(#function, "소켓 닫아요~")
        
        socket?.disconnect()
        socket?.removeAllHandlers()
        socket = nil
        
        manager.disconnect()
        
        timer?.invalidate()
        timer = nil
    }
    
    private func receive(completion: @escaping (ChannelChatResponseDTO) -> ()) {
        print("🤲🏻 receive start")
        
        socket?.on("channel") { dataArray, ack in
            print("🤲🏻 CHANNEL RECEIVED", dataArray, ack)
            
            guard let data = dataArray.first else { return }
            let decodingData = ResponseDecoder.decode(ChannelChatResponseDTO.self, data: data)
            
            switch decodingData {
            case .success(let success):
                print("채팅 디코딩 성공!")
                completion(success)
                
            case .failure(let failure):
                print("채팅 디코딩 실패", failure)
            }
        }
    }
    
    private func ping() {
        print("🙋🏻‍♀️ ping start")
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            print("🙋🏻‍♀️ ping")
            self?.socket?.emit("ping")
        })
    }
    
}

extension SocketIOManager {
    
    private func addEventHandler() {
        socket?.on(clientEvent: .connect) { data, ack in
            print("\n✅ socket connected\n")
        }
        
        socket?.on(clientEvent: .disconnect) { data, ack in
            print("\n🚨 socket disconnected\n")
        }
    }
    
}
