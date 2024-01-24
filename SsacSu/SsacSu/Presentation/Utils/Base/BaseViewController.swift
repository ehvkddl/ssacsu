//
//  File.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/08.
//

import UIKit
import SnapKit
import RxSwift

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Background.primary
        
        configureView()
        setConstraints()
        configureNavigationBar()
    }
    
    func configureView() {}
    
    func setConstraints() {}
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .Brand.white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .Brand.black
        
        guard let bar = navigationController,
                bar.isNavigationBarHidden == true else { return }
        
        let divider = Divider()
        
        view.addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(1)
        }
    }
    
}
