//
//  NewImageViewController.swift
//  diplom_2
//
//  Created by Сергей Недведский on 25.01.25.
//

import SnapKit
import UIKit

class GalleryImageViewController: UIViewController {

    var imagesArray = StorageManagaer.shared.loadImages()

    var counter = 0

    var isNewImageAdded = false

    var imageViewCurrent = UIImageView()
    var uiImageViewsArray: [UIImageView] = []

    let currentX: CGFloat = 10
    var currentY: CGFloat = 180

    let widthButton: CGFloat = 70
    var heightImage: CGFloat = 200

    var sizeFont: CGFloat = 50

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "←"
        label.numberOfLines = 1
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = "→"
        label.numberOfLines = 1
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 40)
        return label
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
    
    private let emptyBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Constansts.btnTextColor, for: .normal)
        button.setTitle(Constansts.emptyGallery, for: .normal)
        button.backgroundColor = Constansts.btnColor
        button.isUserInteractionEnabled = true
        button.roundCorners()
        return button
    }()

    var isFavorite = false
    var isChangedFavorite = false
    var isTextChanged = false
    var changedToSave = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configueUI()

    }

    private func configueUI() {
        if !imagesArray.isEmpty {
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
                dateLabel.frame.height + dateLabel.frame.origin.y
                + Constansts.step

            heightImage = view.frame.height * 0.5

            self.view.backgroundColor = .white

            self.viewSecond.addSubview(firstLabel)
            firstLabel.layer.cornerRadius = widthButton / 2
            firstLabel.frame = CGRect(
                x: 80, y: view.frame.height - 120,
                width: widthButton,
                height: widthButton)

            let tapActionLeft = UITapGestureRecognizer(
                target: self, action: #selector(tapActionLeft))
            firstLabel.addGestureRecognizer(tapActionLeft)

            self.viewSecond.addSubview(secondLabel)
            secondLabel.layer.cornerRadius = widthButton / 2
            secondLabel.frame = CGRect(
                x: view.frame.width - 150, y: view.frame.height - 120,
                width: widthButton,
                height: widthButton)

            let tapActionRight = UITapGestureRecognizer(
                target: self, action: #selector(tapActionRight))
            secondLabel.addGestureRecognizer(tapActionRight)

            if let image = StorageManagaer.shared.loadImage(
                filename: imagesArray[counter].imageSrc)
            {
                imageViewCurrent.image = image
            }

            imageViewCurrent.contentMode = .scaleAspectFill
            imageViewCurrent.clipsToBounds = true
            imageViewCurrent.frame = CGRect(
                x: 0, y: currentY, width: view.frame.width,
                height: heightImage)
            self.viewSecond.addSubview(imageViewCurrent)
            uiImageViewsArray.append(imageViewCurrent)

            print(imageViewCurrent.frame.height)
            print(imageViewCurrent.frame.origin.y)

            nameTextField.frame = CGRect(
                x: Constansts.step,
                y: imageViewCurrent.frame.height
                    + imageViewCurrent.frame.origin.y
                    + Constansts.step,
                width: view.frame.width - Constansts.step * 2,
                height: Constansts.textFieldHeight)
            self.viewSecond.addSubview(nameTextField)

            let tapDetected = UITapGestureRecognizer(
                target: self, action: #selector(tapDetected))
            viewSecond.addGestureRecognizer(tapDetected)

            registerKeyboardNotification()

            likeButton.frame = CGRect(
                x: view.frame.width - Constansts.step
                    - Constansts.btnDefaultSize,
                y: Constansts.stepTop, width: Constansts.btnDefaultSize,
                height: Constansts.btnDefaultSize)
            self.viewSecond.addSubview(likeButton)

            let favoriteAction = UIAction { _ in
                self.favoriteToggle()
            }
            likeButton.addAction(favoriteAction, for: .touchUpInside)

            reloadData()
        } else{
            view.backgroundColor = .white
            view.addSubview(emptyBackButton)
            emptyBackButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            let backAction = UIAction { _ in
                self.navigationController?.popViewController(animated: true)
            }
            emptyBackButton.addAction(backAction, for: .touchUpInside)
        }
    }

    private func toBack() {
        isChangedToSave()
        if changedToSave {
            StorageManagaer.shared.saveChangedImages(images: imagesArray)
        }
        if isNewImageAdded {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func isChangedToSave() {
        let currentImage = imagesArray[counter]
        if isTextChanged {
            if let name = nameTextField.text {
                if !name.isEmpty {
                    if name != currentImage.imageName {
                        currentImage.setImageName(imageName: name)
                        changedToSave = true
                    }
                }
            }
        }

        if isChangedFavorite {
            currentImage.setIsFavorite(isFavorite: isFavorite)
            changedToSave = true
        }

        print(changedToSave)
    }

    @objc func tapActionLeft() {
        isChangedToSave()

        counter -= 1
        if counter < 0 {
            counter = imagesArray.count - 1
        }

        let imageViewBack = UIImageView()
        imageViewBack.image = imageViewCurrent.image
        imageViewBack.contentMode = .scaleAspectFill
        imageViewBack.clipsToBounds = true
        imageViewBack.frame = CGRect(
            x: 0, y: currentY, width: view.frame.width,
            height: self.heightImage)
        self.viewSecond.addSubview(imageViewBack)
        if let image = StorageManagaer.shared.loadImage(
            filename: imagesArray[counter].imageSrc)
        {
            imageViewCurrent.image = image
        }

        reloadData()

        UIView.animate(withDuration: 0.3) {
            imageViewBack.frame.origin.x = -self.view.frame.width
        } completion: { _ in
            imageViewBack.removeFromSuperview()
        }

    }

    @objc func tapActionRight() {
        isChangedToSave()

        counter += 1
        if counter >= imagesArray.count {
            counter = 0
        }

        let imageViewNext = UIImageView()
        if let image = StorageManagaer.shared.loadImage(
            filename: imagesArray[counter].imageSrc)
        {
            imageViewNext.image = image
        }
        imageViewNext.contentMode = .scaleAspectFill
        imageViewNext.clipsToBounds = true
        imageViewNext.frame = CGRect(
            x: view.frame.width, y: currentY, width: view.frame.width,
            height: self.heightImage)
        self.viewSecond.addSubview(imageViewNext)

        reloadData()

        UIView.animate(withDuration: 0.3) {
            imageViewNext.frame = CGRect(
                x: 0, y: self.currentY,
                width: self.view.frame.width,
                height: self.heightImage)
        } completion: { _ in
            self.imageViewCurrent.image = imageViewNext.image
            imageViewNext.removeFromSuperview()

        }

    }

    private func favoriteToggle() {
        isChangedFavorite = true
        isFavorite = !isFavorite
        likeButton.layer.opacity = isFavorite ? 1 : Constansts.likeOpacity
    }

    @objc func tapDetected() {
        view.endEditing(true)
    }

    private func reloadData() {
        dateLabel.text = imagesArray[counter].createdDate
        nameTextField.text = imagesArray[counter].imageName
        isFavorite = imagesArray[counter].isFavorite
        likeButton.layer.opacity = isFavorite ? 1 : Constansts.likeOpacity
        isChangedFavorite = false
        isTextChanged = false
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
            isTextChanged = true
        } else if notification.name == UIResponder.keyboardWillShowNotification
        {
            offset = -frame.height
        }

        UIView.animate(withDuration: duration) {
            self.viewSecond.frame.origin.y = offset
        }
    }

}

extension GalleryImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
