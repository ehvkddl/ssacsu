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
    private let disposeBag = DisposeBag()
    
    init(
        userRepository: UserRepository,
        workspaceRepository: WorkspaceRepository
    ) {
        self.userRepository = userRepository
        self.workspaceRepository = workspaceRepository
    }
    
    struct Input {
        let createWorkspaceButtonTapped: ControlEvent<Void>
        let navigationBarTapped: ControlEvent<UITapGestureRecognizer>
        let itemSelected: ControlEvent<IndexPath>
        let modelSelected: ControlEvent<WorkspaceSectionItem>
    }
    
    struct Output {
        let workspace: PublishSubject<Workspace?>
        let workspaceSections: PublishRelay<[WorkspaceSection]>
    }
    
    func transform(input: Input) -> Output {
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
        
        // 채널 정보
        workspaceID
            .compactMap { $0 }
            .map { id in
                UserDefaults.standard.set(id, forKey: "WorkspaceID")
                
                return id
            }
            .flatMap { self.workspaceRepository.fetchSingleWorkspace(id: $0) }
            .subscribe { result in
                switch result {
                case .success(let response):
                    workspace.onNext(response.toDomain())
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        workspaceID
            .filter { $0 == nil }
            .flatMap { _ in self.workspaceRepository.fetchWorkspace() }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.workspaceID.onNext(success.first?.workspaceID)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        workspace
            .compactMap { $0 }
            .map { $0.channels }
            .compactMap { $0 }
            .map { $0.sorted { lhs, rhs in
                lhs.channelID < rhs.channelID
            }}
            .map { $0.map { channel in
                WorkspaceSectionItem.channel(channel)
            }}
            .subscribe { items in
                var items = items
                items.append(WorkspaceSectionItem.add(.channel))
                
                channelItems.onNext(items)
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
