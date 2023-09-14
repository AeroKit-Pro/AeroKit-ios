//
//  AirportsFilterRunwayLightView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 6.05.23.
//

import UIKit

final class AirportsFilterRunwayLightView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Runway light"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold) // TODO: fonts
        return label
    }()

    let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = .black
        return switchView
    }()
    
    var selectedState: Bool {
        set { switchView.isOn = newValue }
        get { switchView.isOn }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(titleLabel, switchView)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.equalToSuperview().offset(10)
        }

        switchView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    private func setupUI() {
        backgroundColor = .flg_light_dark_white
        layer.cornerRadius = 16
    }
}
