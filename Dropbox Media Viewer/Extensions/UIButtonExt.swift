//
//  UIButtonExt.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit


// MARK: - UITabBarButton -

class UITabBarButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.bounce()
    }

    private func setup() {
        self.layer.masksToBounds = true
    }
}
