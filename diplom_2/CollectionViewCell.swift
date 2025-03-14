//
//  CollectionViewCell.swift
//  lesson_27
//
//  Created by Сергей Недведский on 28.01.25.
//

import SnapKit
import UIKit

class CollectionViewCell: UICollectionViewCell {

    static var identifer: String { "\(Self.self)" }

    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "loader")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }

    private func configureUI() {
        contentView.addSubview(userImageView)
        contentView.clipsToBounds = true

        userImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with model: Image, size: Int) {
        self.userImageView.image = UIImage(named: "loader")
        DispatchQueue.global().async {
            if let image = StorageManagaer.shared.loadImage(
                filename: model.imageSrc)
            {
                let newSize = CGSize(width: size, height: size)
                if let resizedImage = image.resized(to: newSize) {
                    DispatchQueue.main.async {
                        self.userImageView.image = resizedImage
                    }
                }
            }
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
