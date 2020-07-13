import UIKit

class DMLaunchViewController: DMViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchApp()
    }

    private func launchApp() {
        if let token = UserDefaults.standard.string(forKey: ConstantsUserDefaults.accessToken) {
            ServiceLocator.shared.registerService(service: MainSessionManager.default(token: token))
            self.showActivityIndicator()
            AccountsDataProvider.default().getUser { userModel, error in
                self.dismissActivityIndicator()

                if let user = userModel {
                    ServiceLocator.shared.registerService(service: user)
                    self.userAuthorized()
                } else {
                    self.showAlertWith(message: error)
                    self.userNotAuthorized()
                }
            }
        } else {
            self.userNotAuthorized()
            ServiceLocator.shared.registerService(service: MainSessionManager.default())
        }
    }
    
    private func userNotAuthorized() {
        let auth = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()!
        auth.modalPresentationStyle = .fullScreen
        self.present(auth, animated: false, completion: nil)
    }
    
    private func userAuthorized() {
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()!
        UIApplication.shared.delegate?.window!!.rootViewController = animate(tabBar)
    }
}

public func animate(_ controller: UIViewController) -> UIViewController {
    let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
    controller.view.addSubview(overlayView)
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .transitionCrossDissolve, animations: {
        overlayView.alpha = 0
    }, completion: { finished in
        overlayView.removeFromSuperview()
    })
    return controller
}
