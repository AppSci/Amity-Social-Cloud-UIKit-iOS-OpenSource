// The MIT License (MIT)
//
// Copyright (c) 2019 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Photos

/// Closure convenience API.
/// Keep this simple enough for most users. More niche features can be added to ImagePickerControllerDelegate.
@objc extension UIViewController {
    
    /// Present a image picker
    ///
    /// - Parameters:
    ///   - imagePicker: The image picker to present
    ///   - animated: Should presentation be animated
    ///   - select: Selection callback
    ///   - deselect: Deselection callback
    ///   - cancel: Cancel callback
    ///   - finish: Finish callback
    ///   - completion: Presentation completion callback
    public func presentImagePicker(_ imagePicker: AmityImagePickerController, animated: Bool = true, select: ((_ asset: PHAsset) -> Void)?, deselect: ((_ asset: PHAsset) -> Void)?, cancel: (([PHAsset]) -> Void)?, finish: (([PHAsset]) -> Void)?, completion: (() -> Void)? = nil) {
        authorize { [weak self] in
            // Set closures
            imagePicker.onSelection = select
            imagePicker.onDeselection = deselect
            imagePicker.onCancel = cancel
            imagePicker.onFinish = finish

            // And since we are using the blocks api. Set ourselfs as delegate
            imagePicker.imagePickerDelegate = imagePicker

            // Present
            imagePicker.modalPresentationStyle = .overFullScreen
            self?.present(imagePicker, animated: animated, completion: completion)
        }
    }

    private func authorize(_ authorized: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async(execute: authorized)
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.presentAlertController()
                }
            default:
                break
            }
        }
    }
    
    private func presentAlertController() {
        let alertController = UIAlertController (title: AmityUIKitManagerInternal.shared.imagesPermissionDeniedText, message: "", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AmityImagePickerController {
    public static var currentAuthorization : PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
}

/// ImagePickerControllerDelegate closure wrapper
extension AmityImagePickerController: AmityImagePickerControllerDelegate {
    public func imagePicker(_ imagePicker: AmityImagePickerController, didSelectAsset asset: PHAsset) {
        onSelection?(asset)
    }

    public func imagePicker(_ imagePicker: AmityImagePickerController, didDeselectAsset asset: PHAsset) {
        onDeselection?(asset)
    }

    public func imagePicker(_ imagePicker: AmityImagePickerController, didFinishWithAssets assets: [PHAsset]) {
        onFinish?(assets)
    }

    public func imagePicker(_ imagePicker: AmityImagePickerController, didCancelWithAssets assets: [PHAsset]) {
        onCancel?(assets)
    }

    public func imagePicker(_ imagePicker: AmityImagePickerController, didReachSelectionLimit count: Int) {
        
    }
}
