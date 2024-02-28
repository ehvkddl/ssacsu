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
    case dm(Dms)
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
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepository,
        workspaceRepository: WorkspaceRepository,
        channelRepository: ChannelRepository
    ) {
        self.userRepository = userRepository
        self.workspaceRepository = workspaceRepository
        self.channelRepository = channelRepository
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
                owner.workspaceRepository.fetchSingleWorkspace(id: id) { response in
                    workspace.onNext(response)
                }
                
                owner.channelRepository.fetchMyChannels(id: id) { response in
                    let items = response
                        .sorted(by: { lhs, rhs in
                            lhs.createdAt < rhs.createdAt
                        })
                        .map { WorkspaceSectionItem.channel($0) }
                    
                    channelItems.onNext(items)
                }
                
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
        
        // 임시 DM
        let testUser = User(userID: 1, email: "test@sesac.com", nickname: "test", profileImage: nil)
        
        Observable.just([
            Dms(workspaceID: 182, RoomID: 1, createdAt: Date(), user: testUser),
            Dms(workspaceID: 182, RoomID: 2, createdAt: Date(timeIntervalSinceNow: 1), user: testUser),
            Dms(workspaceID: 182, RoomID: 3, createdAt: Date(timeIntervalSinceNow: 2), user: testUser),
            Dms(workspaceID: 182, RoomID: 4, createdAt: Date(timeIntervalSinceNow: 3), user: testUser)
        ])
        .map { $0.map { dms in
            WorkspaceSectionItem.dm(dms)
        }}
        .subscribe { items in
            var items = items
            items.append(WorkspaceSectionItem.add(.dm))
            
            dmsItems.onNext(items)
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
