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
        navigationController?.navigationBar.backgroundColor = .Brand.white
        navigationController?.navigationBar.tintColor = .Brand.black
        
        guard navigationController != nil else { return }
        
        let divider = Divider()
        
        view.addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(1)
        }
    }
    
}
