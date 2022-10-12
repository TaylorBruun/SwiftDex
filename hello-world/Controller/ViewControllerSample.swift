//
//  ViewController.swift
//  hello-world
//
//  Created by Taylor on 8/12/22.
//

import UIKit

class ViewControllerSample: UIViewController {

    private let vm = HelloWorldViewModelSample()

    private let titleLabel = UILabel()

    private let button = UIButton()
    private let button2 = UIButton()



    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = vm.titleText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
//        titleLabel.backgroundColor = .red

        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.setTitle("Let's Groove", for: .normal)



        view.addSubview(titleLabel)
        view.addSubview(button)




        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),

            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),


        ])

        button.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
    }

    @objc private func handleClick() {
//        vm.alterTitleText("Pepper")
//        titleLabel.text = vm.titleText
        let newController = OhManAnotherControllerSample()
//        newController.modalPresentationStyle = .fullScreen
        self.present(newController, animated: true)
    }
}

class HelloWorldViewModelSample {
    private(set) var titleText: String = "Hello World"

    func alterTitleText(_ newText: String) {
        titleText = newText
    }
}

class OhManAnotherControllerSample : UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .magenta
    }
}
