import UIKit
import PhotosUI

final class AvatarUploadSettingsViewController: UIViewController, UINavigationControllerDelegate {
    fileprivate typealias ImageMethods = (data: String?, error: String?)
    fileprivate typealias AvatarMethods = (id: UploadMethods, title: String, symbol: String, color: UIColor, size: Double)
    fileprivate enum UploadMethods: String {
        case capture
        case upload
        case delete
        
        var description: String {
            return self.rawValue
        }
    }
    
    private var avatarUploadView = AvatarUploadSettingsView()
    fileprivate var staticUploadMethods: [AvatarMethods] {
        return [
            AvatarMethods(
                id: .capture,
                title: "Take Photo",
                symbol: "camera",
                color: UIColor.label,
                size: 16
            ),
            AvatarMethods(
                id: .upload,
                title: "Choose Photo",
                symbol: "photo.on.rectangle.angled",
                color: UIColor.label,
                size: 16
            ),
            AvatarMethods(
                id: .delete,
                title: "Delete Photo",
                symbol: "trash",
                color: UIColor.systemRed,
                size: 16
            )
        ]
    }
    
    internal var onDismiss: ((String?) -> Void)?
    
    override func loadView() {
        view = avatarUploadView
    }
    
    override func viewDidLoad() {
        avatarUploadView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AvatarUploadMethodsCell")
        avatarUploadView.tableView.dataSource = self
        avatarUploadView.tableView.delegate = self
    }
    
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Error",
                message: "Physical camera is not available on this device configuration.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func openAlbum() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let albumPicker = PHPickerViewController(configuration: configuration)
        albumPicker.delegate = self
        self.present(albumPicker, animated: true, completion: nil)
    }
    
    private func deleteAvatar() {
        self.onDismiss?(nil)
        self.dismiss(animated: true)
    }
    
    private func convertToBase64(image: UIImage) -> String? {
        var base64String = Empty.String
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
        if let imageData = image.pngData() {
            base64String = imageData.base64EncodedString()
        }
        
        return base64String
    }
    
    private func isImageValid(image: String, limit: Double) -> Bool {
        let size = Double(image.count) / 1_000_000.0
        
        return size <= limit
    }
    
    private func handleSelectedImage(_ image: UIImage) -> ImageMethods {
        var result: ImageMethods = (data: nil, error: nil)
        guard let base64 = convertToBase64(image: image) else {
            result.error = "Fail to upload image: Convertion failed"
            
            return result
        }
        
        if self.isImageValid(image: base64, limit: 5.0) {
            result.data = base64
        } else {
            result.error = "File too large"
        }
        
        return result
    }
}

extension AvatarUploadSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticUploadMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarUploadMethodsCell", for: indexPath)
        
        let entry = staticUploadMethods[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = entry.title
        config.textProperties.font = .systemFont(ofSize: entry.size)
        config.image = UIImage(systemName: entry.symbol)
        config.imageToTextPadding = entry.size * 0.5
        config.imageProperties.tintColor = entry.color
        config.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: entry.size * 0.8, weight: .medium)
        config.imageProperties.reservedLayoutSize = CGSize(width: entry.size, height: entry.size)

        cell.contentConfiguration = config
        
        return cell
    }
}

extension AvatarUploadSettingsViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = self.staticUploadMethods[indexPath.row]
        switch selectedItem.id {
        case .capture:
            openCamera()
        case .upload:
            openAlbum()
        case .delete:
            deleteAvatar()
        }
    }
}

extension AvatarUploadSettingsViewController: PHPickerViewControllerDelegate {
    internal func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let selectedImage = object as? UIImage {
                DispatchQueue.main.async {
                    guard let imgMethods: ImageMethods = self?.handleSelectedImage(selectedImage) else { return }
                    if let err = imgMethods.error, !err.isEmpty {
                        let alert = UIAlertController(
                            title: "ERROR",
                            message: err,
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                        
                        return
                    }
                    
                    guard let data = imgMethods.data, !data.isEmpty else {
                        let alert = UIAlertController(
                            title: "ERROR",
                            message: "Image is empty",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                        
                        return
                    }
                    
                    self?.onDismiss?(data)
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}

extension AvatarUploadSettingsViewController: UIImagePickerControllerDelegate {
    internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let imgMethods: ImageMethods = self.handleSelectedImage(selectedImage)
            if let err = imgMethods.error, !err.isEmpty {
                let alert = UIAlertController(
                    title: "ERROR",
                    message: err,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            
            guard let data = imgMethods.data, !data.isEmpty else {
                let alert = UIAlertController(
                    title: "ERROR",
                    message: "Image is empty",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            
            self.onDismiss?(data)
            self.dismiss(animated: true)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
