//
//  GalleryImageViewController.swift
//  diplom_2
//
//  Created by Сергей Недведский on 25.01.25.
//

import UIKit

protocol NewImageViewControllerDelegate: AnyObject {
    func reloadCollectionView()
}

final class NewImageViewController: UIViewController {

    let currentX: CGFloat = 10
    var currentY: CGFloat = 180

    let widthButton: CGFloat = 70
    var heightImage: CGFloat = 200

    var sizeFont: CGFloat = 50
    
    var isFavorite = false

    private let imageViewCurrent: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Constansts.dateString
        label.numberOfLines = 1
        label.textColor = Constansts.btnTextColor
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: Constansts.titleDefaultSize)
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constansts.imageName
        textField.borderStyle = .roundedRect
        textField.roundCorners()
        return textField
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constansts.btnColor
        button.isUserInteractionEnabled = true
        button.roundCorners()
        button.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        button.layer.opacity = Constansts.likeOpacity
        return button
    }()

    private let viewSecond: UIView = {
        let view = UIView()
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constansts.btnColor
        button.isUserInteractionEnabled = true
        button.roundCorners()
        button.setBackgroundImage(
            UIImage(named: Constansts.backImageString), for: .normal)
        return button
    }()

    private var ifPicker = false

    weak var delegate: NewImageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configueUI()

    }

    private func configueUI() {
        viewSecond.frame = CGRect(
            x: 0, y: 0,
            width: view.frame.width,
            height: view.frame.height)
        view.addSubview(viewSecond)

        backButton.frame = CGRect(
            x: Constansts.step, y: Constansts.stepTop,
            width: Constansts.btnDefaultSize,
            height: Constansts.btnDefaultSize)
        viewSecond.addSubview(backButton)

        dateLabel.frame = CGRect(
            x: backButton.frame.origin.x + Constansts.btnDefaultSize,
            y: Constansts.stepTop,
            width: view.frame.width
                - (Constansts.btnDefaultSize + Constansts.step) * 2,
            height: Constansts.btnDefaultSize)
        viewSecond.addSubview(dateLabel)

        let backAction = UIAction { _ in
            self.toBack()
        }
        backButton.addAction(backAction, for: .touchUpInside)

        currentY =
            dateLabel.frame.height + dateLabel.frame.origin.y + Constansts.step

        heightImage = view.frame.height * 0.5

        self.view.backgroundColor = .white

        imageViewCurrent.image = UIImage(named: Constansts.newImagePicker)
        imageViewCurrent.contentMode = .scaleAspectFit
        imageViewCurrent.clipsToBounds = true
        imageViewCurrent.frame = CGRect(
            x: 0, y: currentY, width: view.frame.width,
            height: heightImage)
        self.viewSecond.addSubview(imageViewCurrent)

        print(imageViewCurrent.frame.height)
        print(imageViewCurrent.frame.origin.y)

        nameTextField.frame = CGRect(
            x: Constansts.step,
            y: imageViewCurrent.frame.height + imageViewCurrent.frame.origin.y
                + Constansts.step,
            width: view.frame.width - Constansts.step * 2,
            height: Constansts.textFieldHeight)
        self.viewSecond.addSubview(nameTextField)

        let tapDetected = UITapGestureRecognizer(
            target: self, action: #selector(tapDetected))
        viewSecond.addGestureRecognizer(tapDetected)

        registerKeyboardNotification()

        likeButton.frame = CGRect(
            x: view.frame.width - Constansts.step - Constansts.btnDefaultSize,
            y: Constansts.stepTop, width: Constansts.btnDefaultSize,
            height: Constansts.btnDefaultSize)
        self.viewSecond.addSubview(likeButton)

        let tapActionUserImage = UITapGestureRecognizer(
            target: self, action: #selector(tapActionUserImage))
        imageViewCurrent.addGestureRecognizer(tapActionUserImage)
        
        let favoriteAction = UIAction { _ in
            self.favoriteToggle()
        }
        likeButton.addAction(favoriteAction, for: .touchUpInside)
    }
    
    private func toSwiper() {
        let controller = GalleryImageViewController()
        controller.isNewImageAdded = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func toBack() {
        if ifPicker {
            let image = imageViewCurrent.image!
            guard let imageName = StorageManagaer.shared.savelmage(image) else {
                return
            }

            let imageObject = Image(imageSrc: imageName)

            if let name = nameTextField.text {
                if !name.isEmpty {
                    imageObject.setImageName(imageName: name)
                }
            }

            if let date = dateLabel.text{
                imageObject.setCreatedDate(createdDate: date)
            }
            
            imageObject.setIsFavorite(isFavorite: isFavorite)

            StorageManagaer.shared.saveImage(image: imageObject)
            delegate?.reloadCollectionView()
            toSwiper()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func tapActionLeft() {

    }

    @objc func tapDetected() {
        view.endEditing(true)
    }

    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChangedFrame(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChangedFrame(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardChangedFrame(_ notification: Notification) {
        guard let info = notification.userInfo,
            let duration =
                (info[UIResponder.keyboardAnimationDurationUserInfoKey]
                as? NSNumber)?.doubleValue,
            let frame =
                (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue
        else { return }

        var offset: CGFloat = 0
        if notification.name == UIResponder.keyboardWillHideNotification {
            offset = 0
        } else if notification.name == UIResponder.keyboardWillShowNotification
        {
            offset = -frame.height
        }

        UIView.animate(withDuration: duration) {
            self.viewSecond.frame.origin.y = offset
        }
    }

    func showPicker(with source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            print(Constansts.pickerError)
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self

        present(picker, animated: true)
    }

    @objc func tapActionUserImage() {
        showPickerAlert()
    }
    
    private func favoriteToggle(){
        isFavorite = !isFavorite
        likeButton.layer.opacity = isFavorite ? 1 : Constansts.likeOpacity
    }

    func showPickerAlert() {
        let alert = UIAlertController(
            title: Constansts.pickerTitle, message: nil,
            preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(
            title: Constansts.pickerCamera, style: .default
        ) { _ in
            self.showPicker(with: .camera)
        }
        alert.addAction(cameraAction)

        let libraryAction = UIAlertAction(
            title: Constansts.pickerGallery, style: .default
        ) { _ in
            self.showPicker(with: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let cacelAction = UIAlertAction(
            title: Constansts.pickerCancel, style: .cancel)
        alert.addAction(cacelAction)

        present(alert, animated: true)
    }

}

extension NewImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewImageViewController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        var chosenImage = UIImage()

        if let image = info[.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[
            UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            chosenImage = image
        }
        imageViewCurrent.image = chosenImage
        self.ifPicker = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Constansts.timeFormat
        let stringDate = formatter.string(from: date)
        dateLabel.text = stringDate

        picker.dismiss(animated: true)
    }
}
