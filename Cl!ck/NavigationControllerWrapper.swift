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
            return true // 적절한 조건을 설정하여 제스처 인식 여부를 결정할 수 있습니다.
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
