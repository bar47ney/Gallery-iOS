//
//  InitialViewController.swift
//  diplom_2
//
//  Created by Сергей Недведский on 25.01.25.
//

import UIKit

class InitialViewController: UIViewController {

    var counter = 0
    var passwordCheck = 2
    var currentPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constansts.themeColor

        if let password = StorageManagaer.shared.loadPassword() {
            currentPassword = password
            passwordCheck = 1
        } else {
            currentPassword = nil
            passwordCheck = 2
        }

        showAlert(
            title: "Hello!",
            message: "Password, please",
            cancelBtn: false,
            password: true,
            type: .alert,
            currentPassword: currentPassword,
            counter: counter
        ) { password in
            if let password = password {
                self.currentPassword = password
            }
            self.toColletion()
        }
    }

    private func toColletion() {
        counter += 1
        if counter == passwordCheck {
            if passwordCheck == 2 {
                let controller = CollectionViewController()
                if let password = currentPassword{
                    StorageManagaer.shared.savePassword(password: password)
                }
                navigationController?.setViewControllers(
                    [controller], animated: true)
            } else if passwordCheck == 1 {
                let controller = CollectionViewController()
                navigationController?.setViewControllers(
                    [controller], animated: true)
            }
        } else {
            showAlert(
                title: "Hello!",
                message: "Password, repeat please",
                cancelBtn: false,
                password: true,
                type: .alert,
                currentPassword: currentPassword,
                counter: counter
            ) { password in
                self.toColletion()
            }
        }
    }
}

extension UIViewController {
    func showAlert(
        title: String = "Warning",
        message: String = "Message",
        cancelBtn: Bool = false,
        password: Bool = false,
        type: UIAlertController.Style = UIAlertController.Style.alert,
        currentPassword: String?,
        counter: Int,
        handler: @escaping (String?) -> Void
    ) {
        var alerTtype = type

        if password {
            alerTtype = UIAlertController.Style.alert
        }

        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: alerTtype)
        if password {
            alert.addTextField { textField in
                textField.placeholder = "Пароль"
                textField.isSecureTextEntry = true
            }
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if !password {
            } else {
                if currentPassword != nil {
                    if let password = alert.textFields?.first?.text {
                        print("\(password)")
                        if password == currentPassword {
                            handler(nil)
                        } else {
                            self.showAlert(
                                title: "Try again!",
                                message: "Password, please",
                                cancelBtn: false,
                                password: true,
                                type: .alert,
                                currentPassword: currentPassword,
                                counter: counter
                            ) { password in
                                handler(nil)
                            }
                        }
                    }
                } else {
                    if let password = alert.textFields?.first?.text {
                        if counter == 0 {
                            handler(password)
                        } else {
                            if password == currentPassword {
                                handler(nil)
                            } else {
                                self.showAlert(
                                    title: "Try again!",
                                    message: "Password, please",
                                    cancelBtn: false,
                                    password: true,
                                    type: .alert,
                                    currentPassword: currentPassword,
                                    counter: counter
                                ) { password in
                                    handler(nil)
                                }
                            }
                        }
                    }
                }

            }
        }
        alert.addAction(okAction)

        if cancelBtn {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
        }
        present(alert, animated: true)
    }
}
