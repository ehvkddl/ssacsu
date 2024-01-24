//
//  SplashViewController.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import UIKit

class SplashViewController: BaseViewController {
    
    var vm: SplashViewModel!
    
    let iconImage = {
        let img = UIImageView(image: .ssacsu)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    static func create(
        with viewModel: SplashViewModel
    ) -> SplashViewController {
        let view = SplashViewController()
        view.vm = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accent
        
        vm.showAppropriateView()
    }
    
    override func configureView() {
        view.addSubview(iconImage)
    }
    
    override func setConstraints() {
        iconImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(150)
        }
    }
    
}
