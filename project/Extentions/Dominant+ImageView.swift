import UIKit
import Alamofire

extension UIImageView {
    
    func loadImage(_ url: String, done: @escaping (UIImage) -> Void,  error: @escaping () -> Void) {
        let name = (url as NSString).lastPathComponent
        if let image = loadImageFromDiskWith(fileName: name) {
            done(image)
        } else {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self.saveImage(imageName: name, image: image)
                    done(image)
                } else {
                    error()
                }
            }
        }
    }
    
    func setProfileImage(for user: User?) {
        guard let user = user else {
            setAvatar(UIImage(named: "c 4"))
            return
        }
        
        if let url = user.avatar {
            loadImage(url, done: { image in
                self.setAvatar(image)
            }, error: {
                self.setDefault(for: user.fullName())
            })
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
    
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
}

