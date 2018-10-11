import UIKit
import Alamofire

extension UIImageView {
    
    func setProfileImage(for user: User?) {
        guard let user = user else {
            setAvatar(UIImage(named: "Ellipse 4"))
            return
        }
        
        if let url = user.avatar {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self.setAvatar(image)
                } else {
                    self.setDefault(for: user.fullName())
                }
            }
        } else {
            setDefault(for: user.fullName())
        }

        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    func setAvatar(_ avatar: UIImage?) {
        image = avatar
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    
    func setDefault(for userName: String) {
        setAvatar(LetterImageGenerator.imageWith(name: userName))
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        layer.cornerRadius = frame.size.width / 2
    }
}

