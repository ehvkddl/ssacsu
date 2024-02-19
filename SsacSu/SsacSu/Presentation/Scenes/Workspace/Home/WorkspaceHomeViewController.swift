//
//  WorkspaceHomeViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

class WorkspaceHomeViewController: BaseViewController {
    
    var vm: WorkspaceHomeViewModel!
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<WorkspaceSection> = configureCollectionViewDataSource()
    
    let workspaceImage = {
        let img = UIImageView()
        img.backgroundColor = .blue
        img.layer.cornerRadius = 8
        return img
    }()
    
    let workspaceName = {
        let lbl = UILabel()
        lbl.text = "No Workspace"
        lbl.font = SSFont.style(.title1)
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    let recognizer = UITapGestureRecognizer()
    
    let profileImage = {
        let img = UIImageView()
        img.backgroundColor = .green
        img.layer.cornerRadius = img.frame.width * 0.5
        return img
    }()
    
    let divider = Divider()
    
    let emptyView = WorkspaceEmptyView()
    
    private lazy var workspaceCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        
        view.register(WorkspaceChannelCollectionViewCell.self, forCellWithReuseIdentifier: WorkspaceChannelCollectionViewCell.description())
        view.register(WorkspaceDmsCollectionViewCell.self, forCellWithReuseIdentifier: WorkspaceDmsCollectionViewCell.description())
        view.register(WorkspaceAddCollectionViewCell.self, forCellWithReuseIdentifier: WorkspaceAddCollectionViewCell.description())
        
        view.register(WorkspaceHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkspaceHeaderReusableView.description())
        view.register(WorkspaceFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WorkspaceFooterReusableView.description())
        
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DummyHeaderView")
        
        return view
    }()
    
    static func create(
        with viewModel: WorkspaceHomeViewModel
    ) -> WorkspaceHomeViewController {
        let view = WorkspaceHomeViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workspaceName.addGestureRecognizer(recognizer)
        
        bind()
    }
    
    func bind() {
        let input = WorkspaceHomeViewModel.Input(
            createWorkspaceButtonTapped: emptyView.createWorkspaceButton.rx.tap,
            navigationBarTapped: recognizer.rx.event,
            itemSelected: workspaceCollectionView.rx.itemSelected,
            modelSelected: workspaceCollectionView.rx.modelSelected(WorkspaceSectionItem.self)
        )
        let output = vm.transform(input: input)
        
        output.workspace
            .subscribe(with: self) { owner, workspace in
                guard let workspace else {
                    print("워크스페이스 없다")
                    owner.workspaceName.text = "No Workspace"
                    
                    owner.emptyView.rx.isHidden.onNext(false)
                    owner.workspaceCollectionView.rx.isHidden.onNext(true)
                    
                    return
                }
                
                print("워크스페이스 있다")
                owner.emptyView.rx.isHidden.onNext(true)
                owner.workspaceCollectionView.rx.isHidden.onNext(false)
                
                owner.workspaceName.text = workspace.name
            }
            .disposed(by: disposeBag)
        
        output.workspaceSections
            .bind(to: workspaceCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        [workspaceImage, workspaceName, profileImage,
         divider,
         emptyView, workspaceCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        workspaceImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).inset(16)
            make.size.equalTo(32)
        }
        
        workspaceName.snp.makeConstraints { make in
            make.leading.equalTo(workspaceImage.snp.trailing).offset(8)
            make.centerY.equalTo(workspaceImage)
        }
        
        profileImage.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(16)
            make.centerY.equalTo(workspaceImage)
            make.size.equalTo(32)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(workspaceImage.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(1)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        workspaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension WorkspaceHomeViewController {
    
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<WorkspaceSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<WorkspaceSection> { dataSource, collectionView, indexPath, item in
            
            switch item {
            case .channel(let channel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WorkspaceChannelCollectionViewCell.description(),
                    for: indexPath
                ) as? WorkspaceChannelCollectionViewCell else { return UICollectionViewCell() }
                cell.bind(item: channel)
                
                return cell
                
            case .dm(let dm):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WorkspaceDmsCollectionViewCell.description(),
                    for: indexPath
                ) as? WorkspaceDmsCollectionViewCell else { return UICollectionViewCell() }
                cell.bind(item: dm)
                
                return cell
            
            case .add:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WorkspaceAddCollectionViewCell.description(),
                    for: indexPath
                ) as? WorkspaceAddCollectionViewCell else { return UICollectionViewCell() }
                
                switch indexPath.section {
                case 0: cell.addTitleLabel.text = "채널 추가"
                case 1: cell.addTitleLabel.text = "새 메시지 시작"
                case 2: cell.addTitleLabel.text = "팀원 추가"
                default: break
                }
                
                return cell
            }
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard 0...1 ~= indexPath.section else {
                    return collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "DummyHeaderView",
                        for: indexPath
                    )
                }
                
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WorkspaceHeaderReusableView.description(),
                    for: indexPath
                ) as? WorkspaceHeaderReusableView else { return UICollectionReusableView() }
                
                let sectionModel = dataSource.sectionModels[indexPath.section]
                header.bind(title: sectionModel.header)
                
                return header
                
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WorkspaceFooterReusableView.description(),
                    for: indexPath
                ) as? WorkspaceFooterReusableView else { return UICollectionReusableView() }
                
                return footer
                
            default:
                fatalError()
            }
        }
        
        return dataSource
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sec, env in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(sec == 1 ? 44 : 41)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(41)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(sec == 2 ? 5 : 56)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(sec == 2 ? 0 : 6)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            section.boundarySupplementaryItems = [header, footer]
            
            return section
        }
        
        return layout
    }
    
}
