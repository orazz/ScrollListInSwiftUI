//
//  PhotoCollectionView.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import UIKit

class PhotoItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PhotoItemCollectionViewCell.self)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fps: FPSLabel = {
        let label = FPSLabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(fps)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(dateLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(descriptionLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 40.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40.0),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        avatarImageView.image = nil
    }
    
    func configure(using item: Photo) {
        usernameLabel.text = item.user.username
        descriptionLabel.text = item.description
        dateLabel.text = item.createdAt.humanReadableDate()
        imageView.lg.setImage(with: URL(string: item.urls.small), placeholder: nil, options: nil, transformer: nil, progress: nil, completion: nil)
        avatarImageView.lg.setImage(with: URL(string: item.user.profileImage.medium), placeholder: nil, options: nil, transformer: nil, progress: nil, completion: nil)
    }
}
