//
//  BaseViewController.swift
//  Diary of feelings - drop your feelings according to the cloud village
//
//  Created by dan phi on 24/05/2023.
//

import Foundation
import UIKit

class BaseViewController<VM: BaseViewModelType>: UIViewController {
    let viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(self.className) is deallocated")
    }

    func handleError(_ error: FError, showingAlert: Bool) {
        switch error {
        case .underMaintenance:
            let vm = MaintenanceViewModel()
            let vc = MaintenanceViewController()
            if let navigationController = navigationController {
                navigationController.pushViewController(vc, animated: true)
            } else {
                present(vc, animated: true)
            }
            return
        case .unauthenticated:
            viewModel.logoutUser()
        default:
            break
        }
        if showingAlert {
//            alert.showAlertOneButton(self, title: AppString.error,
//                                     message: error.localizedDescription,
//                                     buttonTitle: AppString.ok, handler: nil)

        }
    }
    
    func customBackNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let image = UIImage(named: "ic_back")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.backItem?.title = ""
       // navigationController?.navigationBar.tintColor = UIColor(.grey9)
    }

    func customBackNavigationBar(rightBarButtonItem: UIBarButtonItem?, title: String) {
        if let rightBarButtonItem = rightBarButtonItem {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        navigationItem.title = title
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.backButtonDisplayMode = .minimal
        let yourBackImage = UIImage(named: "ic_back")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
     //   navigationController?.navigationBar.tintColor = UIColor(.grey7)
    }
}
