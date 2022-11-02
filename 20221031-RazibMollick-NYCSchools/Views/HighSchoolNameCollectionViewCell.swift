//
//  HighSchoolNameCollectionViewCell.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//

import UIKit

class HighSchoolNameCollectionViewCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var infoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        imageView.image = UIImage(systemName: "info.circle")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 8
        return stack
    }()
    
    var schoolName: String? {
        didSet {
            nameLabel.text = schoolName
        }
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            
        self.backgroundColor = .white
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(infoImageView)
        addSubview(stackView)
        setupContraints()
        }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private func setupContraints() {

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
}
