//
//  HDImageViewController.swift
//  NASA Picture of the Day
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import UIKit

class HDImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var preLoadImage: UIImage?
    var hdImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = preLoadImage
        setupGesture()
        loadHDImage()
    }
}

//MARK: Gesture Setup
extension HDImageViewController {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGesture(gesture: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Image Downloading
extension HDImageViewController {
    func loadHDImage() {
        guard let hdImageURL = hdImageURL,
            let url = URL(string: hdImageURL)
            else {
                return
        }
        
        ImageDownloader().getImage(forURL: url, completion: { [weak self] (imageData, imageError) in
            guard let self = self,
                let imageData = imageData,
                let image = UIImage(data: imageData)
                else {
                    return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
    }
}
