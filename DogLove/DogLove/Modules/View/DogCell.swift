//
//  DogCell.swift
//  DogLove
//
//  Created by M. Ensar Baba on 23.11.2020.
//

import UIKit

import UIKit

class DogCell: UITableViewCell {
    static let reuseIdentifier = "DogCell"

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let dogView: DogView = {
        let view = DogView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(dogView)
        contentView.addSubview(separatorView)

        dogView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dogView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dogView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dogView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    func update(with item: DogSearchResponseElement) {
        dogView.update(with: item)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dogView.reuseCellCalled()
    }
}
