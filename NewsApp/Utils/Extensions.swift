//
//  Extensions.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

extension UIImage {
    static func download(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard data != nil || error == nil else {
                print("Failed to download image")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Failed to download image. Invalide response or statusCode")
                return
            }
            completionHandler(UIImage(data: data!))
        }.resume()
    }
}

extension UILabel {
    func animateTextChangeTo(_ newText: String, duration: TimeInterval, options: UIView.AnimationOptions = []) {
        UIView.transition(with: self,
                          duration: duration,
                          options: options,
                          animations: { [weak self] in
                            self?.text = newText
        }, completion: nil)
    }
}
