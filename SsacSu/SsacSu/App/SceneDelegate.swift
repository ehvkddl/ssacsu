//
//  SceneDelegate.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/03.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let appDIContainer = AppDIContainer()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
        
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        /// Active 상태로 돌아왔을 때 Socket 연결해줘야 함
        /// 그런데 돌아온 화면이 채팅창이 아닌 경우에는 socket 연결안해도 됨
        /// 화면이 채팅 화면인지를 확인해야할 듯?
        /// 채팅 화면 진입시 옵저버 생성 / 채팅 화면 퇴장시 옵저버 삭제
        print("▶️ 액티브")
        
        // 액티브로 돌아오면 돌아왔다고 noti 보내서 채팅 저장하고 socket 연결하기
        postSocketReopenObserver()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("↩️ 백그라운드")
        SocketIOManager.shared.close()
    }


}

extension SceneDelegate {
    
    func postSocketReopenObserver() {
        NotificationCenter.default.post(name: NSNotification.Name("SocketReopen"), object: nil)
    }
    
}
