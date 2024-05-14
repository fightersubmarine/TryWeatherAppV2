//
//  ViewController.swift
//  TryWeatherAppV2
//
//  Created by Алина on 07.05.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
// MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBarSettingLayout()
    }
}

// MARK: - TabBar Configuration

private extension MainTabBarController {
    
    func setupTabBar() {
        viewControllers = [
            generateVC(viewController: MainScreenViewController(),
                       title: "Home",
                       image: UIImage(systemName: "house")),
            generateVC(viewController: CityListViewController(),
                       title: "City List",
                       image: UIImage(systemName: "paperplane"))
        ]
    }
    
    func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    func tabBarSettingLayout() {
        let roundLayer = CAShapeLayer()
        let width = tabBar.bounds.width - CGFloat.topBarPositionX * 2
        let height = tabBar.bounds.height + CGFloat.topBarPositionY * 2
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: CGFloat.topBarPositionX,
                y: tabBar.bounds.minY - CGFloat.topBarPositionY,
                width: width,
                height: height),
                cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: .zero)
        tabBar.itemWidth = width / 4
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.tabBarBackgroud.cgColor
        tabBar.tintColor = .tabBarItemActive
        tabBar.unselectedItemTintColor = .tabBarItemNotActive
        
    }
}


private extension CGFloat {
    static let topBarPositionX: CGFloat = 10
    static let topBarPositionY: CGFloat = 14
}
