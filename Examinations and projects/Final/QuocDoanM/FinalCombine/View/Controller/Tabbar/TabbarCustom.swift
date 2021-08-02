//
//  TabbarCustom.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/15/21.
//

import UIKit
import Combine

final class TabbarCustom: UIView {
    
    private var activeItem: Int = 0
    var subject: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabbarItem], frame: CGRect) {
        self.init(frame: frame)
        layer.backgroundColor = UIColor.white.cgColor
        
        for index in 0 ..< menuItems.count {
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let offsetX = itemWidth * CGFloat(index)
            
            let itemView = createTabItem(item: menuItems[index])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = index
            
            addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offsetX),
                itemView.topAnchor.constraint(equalTo: topAnchor),
            ])
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        activateTab(tab: 0)
    }
    
    private func createTabItem(item: TabbarItem) -> UIView {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        let tabTitleLabel = UILabel()
        tabTitleLabel.text = item.title
        tabTitleLabel.textAlignment = .center
        tabTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tabTitleLabel.clipsToBounds = true
        tabTitleLabel.font = tabTitleLabel.font.withSize(15)
        
        let itemImageView = UIImageView()
        itemImageView.image = item.icon
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = .scaleAspectFill
        
        view.addSubview(tabTitleLabel)
        view.addSubview(itemImageView)
        
        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalToConstant: Define.imgHeight),
            itemImageView.widthAnchor.constraint(equalToConstant: Define.imgHeight),
            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Define.tabbarWidth),
            tabTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: itemImageView.bottomAnchor, constant: 0),
            tabTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        return view
    }
    
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        switchTab(from: activeItem, to: sender.view!.tag)
    }
    
    private func switchTab(from: Int, to: Int) {
        deactivateTab(tab: from)
        activateTab(tab: to)
    }
    
    private func activateTab(tab: Int) {
        let tabToActivate = subviews[tab]
        let borderWidth = tabToActivate.frame.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.red.cgColor
        borderLayer.name = Define.layer
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 2)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction]) {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let this = self else { return }
                this.subject.send(tab)
                this.activeItem = tab
            }
        }
    }
    
    private func deactivateTab(tab: Int) {
        let inactiveTab = subviews[tab]
        let layerToRemove = inactiveTab.layer.sublayers?.filter({ $0.name == Define.layer })
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4,
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction]) {
                layerToRemove?.forEach { $0.removeFromSuperlayer() }
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            }
        }
    }
}

extension TabbarCustom {
    private struct Define {
        static let layer: String = "Active Border"
        static let imgHeight: CGFloat = 44
        static let tabbarWidth: CGFloat = ((UIScreen.main.bounds.width / 3) - imgHeight) / 2
    }
}
