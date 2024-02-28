//
//  WorkspaceHomeViewModel.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

protocol WorkspaceHomeViewModelDelegate {
    func navigationBarTapped()
    func channelTapped(channel: Channel)
}

enum WorkspaceSectionType {
    case channel
    case dm
    case member
    
    var title: String {
        switch self {
        case .channel: return "채널"
        case .dm: return "다이렉트 메시지"
        default: return ""
        }
    }
}

enum WorkspaceSectionItem {
    case channel(Channel)
    case dm(DMsRoom)
    case add(WorkspaceSectionType)
}

struct WorkspaceSection {
    var type: WorkspaceSectionType
    var items: [Item]
}

extension WorkspaceSection: SectionModelType {
    typealias Item = WorkspaceSectionItem
    
    var header: String {
        return type.title
    }
    
    init(original: WorkspaceSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class WorkspaceHomeViewModel: ViewModelType {
    
    var workspaceID = BehaviorSubject<Int?>(value: nil)
    var delegate: WorkspaceHomeViewModelDelegate?
    
    private let userRepository: UserRepository
    private let workspaceRepository: WorkspaceRepository
    private let channelRepository: ChannelRepository
    private let dmsRepository: DmsRepository
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepository,
        workspaceRepository: WorkspaceRepository,
        channelRepository: ChannelRepository,
        dmsRepository: DmsRepository
    ) {
        self.userRepository = userRepository
        self.workspaceRepository = workspaceRepository
        self.channelRepository = channelRepository
        self.dmsRepository = dmsRepository
    }
    
    struct Input {
        let createWorkspaceButtonTapped: ControlEvent<Void>
        let navigationBarTapped: ControlEvent<UITapGestureRecognizer>
        let itemSelected: ControlEvent<IndexPath>
        let modelSelected: ControlEvent<WorkspaceSectionItem>
    }
    
    struct Output {
        let profile: PublishRelay<String?>
        let workspace: PublishSubject<Workspace?>
        let workspaceSections: PublishRelay<[WorkspaceSection]>
    }
    
    func transform(input: Input) -> Output {
        let profile = PublishRelay<String?>()
        
        let workspace = PublishSubject<Workspace?>()
        let channelItems = PublishSubject<[WorkspaceSectionItem]>()
        let dmsItems = PublishSubject<[WorkspaceSectionItem]>()
        
        let workspaceSections = PublishRelay<[WorkspaceSection]>()
        
        input.navigationBarTapped
            .subscribe(with: self) { owner, _ in
                print("워크스페이스 리스트로 보여줘용")
                
                owner.delegate?.navigationBarTapped()
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(channelItems, dmsItems)
            .map { channelItems, dmsItems in
                let memberItem = [WorkspaceSectionItem.add(.member)]
                
                return [
                    WorkspaceSection(type: .channel, items: channelItems),
                    WorkspaceSection(type: .dm, items: dmsItems),
                    WorkspaceSection(type: .member, items: memberItem)
                ]
            }
            .subscribe { sections in
                workspaceSections.accept(sections)
            }
            .disposed(by: disposeBag)
        
        Observable.just(())
            .subscribe(with: self) { owner, _ in
                let fcmToken = UserDefaultsManager.fcmToken
                
                owner.userRepository.storeDeviceToken(fcmToken: fcmToken)
            }
            .disposed(by: disposeBag)
        
        workspaceID
            .compactMap { $0 }
            .subscribe(with: self) { owner, id in
                // 워크스페이스 정보 조회
                owner.workspaceRepository.fetchSingleWorkspace(id: id) { response in
                    workspace.onNext(response)
                }
                
                // 내가 속한 채널 조회
                owner.channelRepository.fetchMyChannels(id: id) { response in
                    var items = response
                        .sorted(by: { lhs, rhs in
                            lhs.createdAt < rhs.createdAt
                        })
                        .map { WorkspaceSectionItem.channel($0) }
                    
                    items.append(WorkspaceSectionItem.add(.channel))
                    
                    channelItems.onNext(items)
                }
                
                // DM 방 조회
                owner.dmsRepository.fetchDmsRoom(id: id) { response in
                    var items = response
                        .sorted { lhs, rhs in
                            lhs.createdAt < rhs.createdAt
                        }
                        .map { WorkspaceSectionItem.dm($0) }
                    
                    items.append(WorkspaceSectionItem.add(.dm))
                    
                    dmsItems.onNext(items)
                }
                
                // 유저 정보 조회
                owner.userRepository.fetchMyProfile { response in
                    profile.accept(response.profileImage)
                }
            }
            .disposed(by: disposeBag)
        
        workspaceID
            .filter { $0 == nil }
            .flatMap { _ in self.workspaceRepository.fetchWorkspace() }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    guard success.isEmpty else {
                        // 속해 있는 워크스페이스 중 첫번째 워크스페이스 보여주기
                        owner.workspaceID.onNext(success.first?.workspaceID)
                        
                        return
                    }
                    
                    // 속해 있는 워크스페이스 없음
                    workspace.onNext(nil)
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.createWorkspaceButtonTapped
            .subscribe { _ in
                print("워크스페이스 생성")
            }
            .disposed(by: disposeBag)
        
        Observable.zip(input.itemSelected, input.modelSelected)
            .subscribe { [unowned self] indexPath, model in
                print("[cell click]", indexPath, model)
                
                switch model {
                case .channel(let channel):
                    delegate?.channelTapped(channel: channel)
                    
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            profile: profile,
            workspace: workspace,
            workspaceSections: workspaceSections
        )
    }
    
}

extension WorkspaceHomeViewModel {
    
    func updateWorkspace(workspaceID: Int?) {
        self.workspaceID.onNext(workspaceID)
    }
    
}
