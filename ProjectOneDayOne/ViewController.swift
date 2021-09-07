//
//  ViewController.swift
//  ProjectOneDayOne
//
//  Created by Nagy Zsófia on 2021. 09. 02..
//  Copyright © 2021. Nagy Zsófia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIView!
    
    let label = UILabel()
    let indicator = UIActivityIndicatorView()
    let myGroup = DispatchGroup()

    
    var num1: Int? {
        didSet {
            guard let num1 = num1, let num2 = num2 else {
                return
            }
            updateUI(number1: num1, number2: num2)
        }
    }

    var num2: Int? {
        didSet {
            guard let num1 = num1, let num2 = num2 else {
                return
            }
            updateUI(number1: num1, number2: num2)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        createBtn()
        setActivityIndicator()
    }
    
    func setLabel() {
        label.text = "Something comes here..."
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        //label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func createBtn() {
        let button = UIView()
        view.addSubview(button)
        button.layer.cornerRadius = 5
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonLabel = UILabel()
        button.addSubview(buttonLabel)
        buttonLabel.text = "Tap me"
        buttonLabel.textColor = .white
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48),
            buttonLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            buttonLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        ])
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(sender:)))
        button.addGestureRecognizer(tapGesture)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        label.isHidden = true
        indicator.isHidden = false
        indicator.startAnimating()
        
        //var params = [2000, 4000]
        myGroup.enter()
        sumPrimes(upto: 2000) { number in
            DispatchQueue.main.async {
                self.num1 = number
                print("első sum: \(self.num1)")
                self.myGroup.leave()
            }
        }
        
        myGroup.enter()
        sumPrimes(upto: 4000) { num in
            DispatchQueue.main.async {
                self.num2 = num
                print("második sum: \(self.num2)")
                self.myGroup.leave()
            }
        }
                
        myGroup.notify(queue: DispatchQueue.main) {
            print("megvan mindkét szám. num1: \(self.num1), num2: \(self.num2)")
        }
        
//        group.notify(queue: DispatchQueue.global()) {
//           print("Completed work: \(movieIds)")
//           // Kick off the movies API calls
//           PlaygroundPage.current.finishExecution()
//         }
    }
    
    func updateUI(number1: Int, number2: Int){
        indicator.stopAnimating()
        label.isHidden = false
        label.text = "\(number1+number2)"
    }
    

    func setActivityIndicator() {
        indicator.style = .large
        view.addSubview(indicator)
        indicator.isHidden = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func sumPrimes(upto n: Int, completion: @escaping (Int) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var primes: [Int] = []
            for number in 2...n {
                var count = 0
                for num in 1..<number {
                    if number%num == 0 {
                        count+=1
                    }
                }
                if count <= 1 {
                    primes.append(number)
                    //print(number, "is prime")
                }
            }
            
            var sum = 0
            for prime in primes{
                sum+=prime
            }
            
            completion(sum)
        }
    }

}

