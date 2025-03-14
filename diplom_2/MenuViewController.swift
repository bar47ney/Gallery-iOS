//
//  MenuViewController.swift
//  diplom_2
//
//  Created by Сергей Недведский on 25.01.25.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Constansts.btnTextColor, for: .normal)
        button.setTitle(Constansts.addString, for: .normal)
        button.backgroundColor = Constansts.btnColor
        button.isUserInteractionEnabled = true
        button.roundCorners()
        return button
    }()
    
    private let viewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Constansts.btnTextColor, for: .normal)
        button.setTitle(Constansts.viewString, for: .normal)
        button.backgroundColor = Constansts.btnColor
        button.isUserInteractionEnabled = true
        button.roundCorners()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configueUI()

        // Do any additional setup after loading the view.
    }

    private func configueUI(){
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.stepTop)
            make.left.equalToSuperview().offset(Constansts.step)
            make.width.height.equalTo(Constansts.btnDefaultSize)
        }
        
        view.addSubview(viewButton)
        viewButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.stepTop)
            make.width.height.equalTo(Constansts.btnDefaultSize)
        }
        
        let viewButtonAction = UIAction { _ in
            self.toSwiper()
        }
        viewButton.addAction(viewButtonAction, for: .touchUpInside)
        
        let addButtonAction = UIAction { _ in
            self.toNewImage()
        }
        addButton.addAction(addButtonAction, for: .touchUpInside)
    }
    
    private func toSwiper() {
        let controller = GalleryImageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func toNewImage() {
        let controller = NewImageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}
