import SwiftUI
import UIKit

struct NavigationControllerWrapper: UIViewControllerRepresentable {
    var viewController: UIViewController

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            // Disable swipe back gesture on certain conditions
            return true // or false based on your condition
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
