//
//  SATScoresViewController.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 11/3/22.
//

import UIKit

class SATScoresViewController: UIViewController {

    private let popUpScoresView = PopUpScoresView()
    
    init(with model: SATScoreModel) {
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        popUpScoresView.popupTitle.text = model.schoolName
        popUpScoresView.testTakerNumberText.text = "Number of SAT test takers: \(model.numOfSatTestTakers)"
        popUpScoresView.mathScoresText.text =   "Math Average Scroe:     \(model.satMathAvgScore)"
        popUpScoresView.readingScoreText.text = "Reading Average Scroe:  \(model.satCriticalReadingAvgScore)"
        popUpScoresView.writingScoreText.text = "Writing Average Scroe:  \(model.satWritingAvgScore)"
        popUpScoresView.popupButton.setTitle("Cancel", for: .normal)
        popUpScoresView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpScoresView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: Pop up View
private class PopUpScoresView: UIView {
    //MARK: UI Elements
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let testTakerNumberText = UILabel(frame: CGRect.zero)
    let mathScoresText = UILabel(frame: CGRect.zero)
    let readingScoreText = UILabel(frame: CGRect.zero)
    let writingScoreText = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    
    let BorderWidth: CGFloat = 1.0
    let sideMergin: CGFloat = 15.0
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PopUpScoresView {
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Popup Background
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.systemBlue.cgColor
        popupView.backgroundColor = .white
        
        popupTitle.textColor = UIColor.white
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        popupTitle.numberOfLines = 0
        popupTitle.textAlignment = .center
        popupTitle.backgroundColor = .systemBlue
        
        
        // testTakerNumberText
        testTakerNumberText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        testTakerNumberText.numberOfLines = 0
        testTakerNumberText.textAlignment = .center
        
        
        // mathTitleText
        mathScoresText.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        mathScoresText.numberOfLines = 0
        mathScoresText.textAlignment = .left
        
        // mathScoreText
        readingScoreText.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        readingScoreText.numberOfLines = 0
        readingScoreText.textAlignment = .left
        
        // writingScoreText
        writingScoreText.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        writingScoreText.numberOfLines = 0
        writingScoreText.textAlignment = .left
        
        // Popup Button
        popupButton.setTitleColor(UIColor.systemBlue, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(testTakerNumberText)
        popupView.addSubview(mathScoresText)
        popupView.addSubview(readingScoreText)
        popupView.addSubview(writingScoreText)
        popupView.addSubview(popupButton)
        
        addSubview(popupView)
    }
    
    func setupLayout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 24),
            popupView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -24),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        
        testTakerNumberText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testTakerNumberText.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            testTakerNumberText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 4),
            testTakerNumberText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: sideMergin),
            testTakerNumberText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -sideMergin)
            ])

        mathScoresText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mathScoresText.topAnchor.constraint(equalTo: testTakerNumberText.bottomAnchor, constant: 8),
            mathScoresText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: sideMergin),
            mathScoresText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -sideMergin)
            ])
        
        readingScoreText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readingScoreText.topAnchor.constraint(equalTo: mathScoresText.bottomAnchor, constant: 8),
            readingScoreText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: sideMergin),
            readingScoreText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -sideMergin)
            ])
        
        writingScoreText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writingScoreText.topAnchor.constraint(equalTo: readingScoreText.bottomAnchor, constant: 8),
            writingScoreText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: sideMergin),
            writingScoreText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -sideMergin),
            writingScoreText.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -sideMergin)
            ])
      
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
    }
}
