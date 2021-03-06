//
//  UIViewController+Ext.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 16.11.21.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.5) {
            containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.color = .systemPurple
        activityIndicator.startAnimating()

    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            if containerView != nil {
                containerView.removeFromSuperview()
                containerView = nil
            }
        }
    }

    func showFromMain(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
