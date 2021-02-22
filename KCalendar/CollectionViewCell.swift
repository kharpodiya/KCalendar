//
//  CollectionViewCell.swift
//  Calander
//
//  Created by mav on 23/10/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
   
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor=UIColor.clear
            layer.cornerRadius=5
            layer.masksToBounds=true
            
            setupViews()
        }
        
        func setupViews() {
            addSubview(lbl)
            lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
            lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
            lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
            lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        }
        
        let lbl: UILabel = {
            let label = UILabel()
            label.text = "00"
            label.textAlignment = .center
            label.font=UIFont.systemFont(ofSize: 20)
            label.translatesAutoresizingMaskIntoConstraints=false
            return label
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
 
}
