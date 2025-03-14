//
//  CollectionViewController.swift
//  lesson_27
//
//  Created by Сергей Недведский on 28.01.25.
//

import SnapKit
import UIKit

class CollectionViewController: UIViewController {

    private var array = StorageManagaer.shared.loadImages()

    private lazy var collectonView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectonView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        collectonView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.identifer)

        collectonView.backgroundColor = Constansts.themeColor
        collectonView.delegate = self
        collectonView.dataSource = self

        return collectonView
    }()
    
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

        configureUI()
    }

    private func configureUI() {
        
        view.backgroundColor = .white

        view.addSubview(collectonView)
        collectonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    )
        -> Int
    {
        print(array.count)
        return array.count
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.identifer,
                for: indexPath) as? CollectionViewCell
        else {
            return UICollectionViewCell()
        }

        item.configure(with: array[indexPath.item], size: (Int(collectionView.frame.size.width) - (16 * 2)) / 3)
        return item
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let side = (Int(collectionView.frame.size.width) - (16 * 2)) / 3
        return CGSize(width: side, height: side)
    }
}

extension CollectionViewController: NewImageViewControllerDelegate{
    func reloadCollectionView() {
        array = StorageManagaer.shared.loadImages()
        collectonView.reloadData()
    }
}
