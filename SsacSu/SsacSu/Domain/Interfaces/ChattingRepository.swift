//
//  ChattingRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import RxSwift

protocol ChattingRepository {
    func fetchChat(of channelID: Int, completion: @escaping ([ChannelChat]) -> Void)
    func createChat(of channelID: Int, chat: ChannelChatRequestDTO, completion: @escaping (ChannelChat) -> Void)
    func openSocket(id channelID: Int, completion: @escaping (ChannelChat) -> ())
    func closeSocket()
}
