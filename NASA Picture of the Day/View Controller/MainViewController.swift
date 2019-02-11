//
//  MainViewController.swift
//  NASA Picture of the Day
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var hdImageURL: String?
    
    enum SegueID {
        static let presentHD = "PresentImage"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != SegueID.presentHD {
            return
        }
        
        segue.destination.transitioningDelegate = self
        guard let hdVC = segue.destination as? HDImageViewController else { return }
        hdVC.preLoadImage = imageView.image
        hdVC.hdImageURL = hdImageURL
    }
    
    private func showAlert() {
        let title = NSLocalizedString("Oops", comment: "Alert Title")
        let body = NSLocalizedString("Something went wrong, please try again later.", comment: "Alert Body")
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel) { [unowned self] action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Data Fetching
extension MainViewController {
    func refresh() {
        APODInteractor().getAPOD { [weak self] (apod, error) in
            guard let self = self else { return }
            
            if error != nil {
                return self.showAlert()
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = apod?.title
            }
            
            guard let apod = apod,
                let imageUrl = URL(string: apod.url)
                else {
                    return self.showAlert()
            }
            
            self.hdImageURL = apod.hdurl
            
            ImageDownloader().getImage(forURL: imageUrl, completion: { (imageData, imageError) in
                guard let imageData = imageData,
                    let image = UIImage(data: imageData)
                    else {
                        return self.showAlert()
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.loadingIndicator.stopAnimating()
                    self.imageView.isHidden = false
                    self.setupGesture()
                }
            })
        }
    }
}

// MARK: Gesture Setup
extension MainViewController {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func tapGesture(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: SegueID.presentHD, sender: self)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createTransition(forPresented: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createTransition(forPresented: false)
    }
    
    private func createTransition(forPresented presented: Bool) -> UIViewControllerAnimatedTransitioning {
        let transition = FadeInOutTransition()
        transition.animateElements = [titleLabel]
        transition.isPresenting = presented
        return transition
    }
}
