(PROTOTYPE) EventualNavigationController
========================================
2017/05/14
Hoon H.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A `UINavigationController` subclass which navigates
to a specific state eventually. This class also provides
queued progressive navigation.



Carthage Install
----------------

    github "eonil/prototype-eventual-navigation-controller"



Getting Started
---------------

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {

        private let w = UIWindow(frame: UIScreen.main.bounds)
        private let nc = EventualNavigationController(rootViewController: UIViewController())
        private let vc1 = UIViewController()
        private let ac2 = UIAlertController(title: "AC2", message: "22", preferredStyle: .alert)
        private let vc3 = UIViewController()
        private let ac4 = UIAlertController(title: "AC4", message: "4444", preferredStyle: .alert)

        private let nc5 = EventualNavigationController()
        private let ac6 = UIAlertController(title: "AC6", message: "666666", preferredStyle: .alert)

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            vc1.view.backgroundColor = .red
            vc3.view.backgroundColor = .green
            nc5.view.backgroundColor = UIColor.blue.withAlphaComponent(1)

            w.makeKeyAndVisible()
            w.rootViewController = nc

            nc.queue = [
                .init(modal: ac2, stack: []),
                .init(modal: ac2, stack: [vc1]),
                .init(modal: ac2, stack: [vc1, vc3]),
                .init(modal: ac2, stack: []),
                .init(modal: nil, stack: [vc3]),
                .init(modal: nc5, stack: [vc3, vc1]),
                .init(modal: nil, stack: [vc3, vc1]),
                .init(modal: nil, stack: [vc3]),
                .init(modal: nil, stack: []),
            ]

            return true
        }

See `EonilEventualNavigationControllerTestdrive` target for working example.
