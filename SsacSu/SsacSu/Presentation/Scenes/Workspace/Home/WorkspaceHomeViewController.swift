//
//  WorkspaceHomeViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/22.
//

import UIKit

import RxDataSources

struct WorkspaceDataSection {
    var header: String
    var items: [Channel]
}

extension WorkspaceDataSection: SectionModelType {
    typealias Item = Channel
    
    init(original: WorkspaceDataSection, items: [Channel]) {
        self = original
        self.items = items
    }
}

class WorkspaceHomeViewController: BaseViewController {
    
    var vm: WorkspaceHomeViewModel!
    
    private lazy var dataSource = configureCollectionViewDataSource()
    
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
        return lbl
    }()
    
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
        view.register(WorkspaceHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkspaceHeaderReusableView.description())
        
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
        
        bind()
    }
    
    func bind() {
        let input = WorkspaceHomeViewModel.Input(
            createWorkspaceButtonTapped: emptyView.createWorkspaceButton.rx.tap
        )
        let output = vm.transform(input: input)
        
        output.workspace
            .subscribe(with: self) { owner, workspace in
                guard workspace != nil else {
                    print("워크스페이스 없다")
                    owner.emptyView.rx.isHidden.onNext(false)
                    owner.workspaceCollectionView.rx.isHidden.onNext(true)
                    return
                }
                
                print("워크스페이스 있다")
                owner.emptyView.rx.isHidden.onNext(true)
                owner.workspaceCollectionView.rx.isHidden.onNext(false)
            }
            .disposed(by: disposeBag)
        
        output.workspace
            .compactMap { $0 }
            .map { $0.channels }
            .compactMap { $0 }
            .map { $0.sorted { lhs, rhs in
                lhs.channelID < rhs.channelID
            }}
            .map { WorkspaceDataSection(header: "채널", items: $0) }
            .map { [$0] }
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
    
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<WorkspaceDataSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<WorkspaceDataSection> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WorkspaceChannelCollectionViewCell.description(),
                for: indexPath
            ) as? WorkspaceChannelCollectionViewCell else { return UICollectionViewCell() }
            
            cell.bind(item: item)
            
            return cell
            
        } configureSupplementaryView: { [unowned self] dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WorkspaceHeaderReusableView.description(),
                    for: indexPath
                ) as? WorkspaceHeaderReusableView else { return UICollectionReusableView() }
                
                let sectionTitle = dataSource.sectionModels[indexPath.section].header
                header.bind(title: sectionTitle)
                
                return header
                
            default:
                fatalError()
            }
        }
        
        return dataSource
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(56)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
}
