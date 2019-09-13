

import UIKit

@IBDesignable
open class CSSView: UIView {

}

@IBDesignable
open class CSSButton: UIButton {

}

@available(iOS 11.0, *)
extension UIView {
	@IBInspectable var shadowRadius: CGFloat {
		set {
			self.layer.shadowRadius = newValue
		}
		get {
			return self.layer.shadowRadius
		}
	}

	@IBInspectable var shadowOpacity: Float {
		set {
			self.layer.shadowOpacity = newValue
		}
		get {
			return self.layer.shadowOpacity
		}
	}

	@IBInspectable var shadowOffset: CGSize {
		set {
			self.layer.shadowOffset = newValue
		}
		get {
			return self.layer.shadowOffset
		}
	}

	@IBInspectable var shadowColor: UIColor? {
		set {
			self.layer.shadowColor = newValue?.cgColor
		}
		get {
			if let color = self.layer.shadowColor {
				return UIColor(cgColor: color)
			} else {
				return nil
			}
		}
	}

	@IBInspectable var borderWidth: CGFloat {
		set {
			self.layer.borderWidth = newValue
		}
		get {
			return self.layer.borderWidth
		}
	}

	@IBInspectable var borderColor: UIColor? {
		set {
			self.layer.borderColor = newValue?.cgColor
		}
		get {
			if let color = self.layer.borderColor {
				return UIColor(cgColor: color)
			} else {
				return nil
			}
		}
	}

	@IBInspectable var cornerRadius: CGFloat  {
		set {
			self.layer.cornerRadius = newValue
		}
		get {
			return self.layer.cornerRadius
		}
	}

	@IBInspectable var cornerPosition: CACornerMask  {
		set {
			self.layer.maskedCorners = newValue
		}
		get {
			return self.layer.maskedCorners
		}
	}


	@IBInspectable var cornerTopLeft: Bool {
		set {
			if newValue {
				self.layer.maskedCorners.insert(.layerMinXMinYCorner)
			} else {
				self.layer.maskedCorners.remove(.layerMinXMinYCorner)
			}
		}
		get {
			return self.layer.maskedCorners.contains(.layerMinXMinYCorner)
		}
	}
	@IBInspectable var cornerTopRight: Bool {
		set {
			if newValue {
				self.layer.maskedCorners.insert(.layerMaxXMinYCorner)
			} else {
				self.layer.maskedCorners.remove(.layerMaxXMinYCorner)
			}
		}
		get {
			return self.layer.maskedCorners.contains(.layerMaxXMinYCorner)
		}
	}

	@IBInspectable var cornerBottomLeft: Bool {
		set {
			if newValue {
				self.layer.maskedCorners.insert(.layerMinXMaxYCorner)
			} else {
				self.layer.maskedCorners.remove(.layerMinXMaxYCorner)
			}
		}
		get {
			return self.layer.maskedCorners.contains(.layerMinXMaxYCorner)
		}
	}
	@IBInspectable var cornerBottomRight: Bool {
		set {
			if newValue {
				self.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
			} else {
				self.layer.maskedCorners.remove(.layerMaxXMaxYCorner)
			}
		}
		get {
			return self.layer.maskedCorners.contains(.layerMaxXMaxYCorner)
		}
	}
}




@IBDesignable
class GradientView: UIView {

	@IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
	@IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
	@IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
	@IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
	@IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
	@IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

	override class var layerClass: AnyClass { return CAGradientLayer.self }

	var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

	func updatePoints() {
		if horizontalMode {
			gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
			gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
		} else {
			gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
			gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
		}
	}
	func updateLocations() {
		gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
	}
	func updateColors() {
		gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		updatePoints()
		updateLocations()
		updateColors()
	}
}


protocol HidesNavigation {

}

class HiddenNavigation: UIViewController {

	@IBInspectable var statusBarWhite: Bool = false

	private var isHidden = false

	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		super.viewWillAppear(animated)

		if #available(iOS 13.0, *) {
			isModalInPresentation = true
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(self.isHidden, animated: animated)
		super.viewWillDisappear(animated)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		self.isHidden = segue.destination is HiddenNavigation
		super.prepare(for: segue, sender: sender)
	}

	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		super.motionEnded(motion, with: event)
		self.navigationController?.popViewController(animated: true)
	}


	override var preferredStatusBarStyle: UIStatusBarStyle {
		if statusBarWhite {
			return .lightContent
		} else {
			return .default
		}
	}
}


extension UIViewController {
	@IBAction func dismissNav(_ sender: Any) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	@IBAction func dismissSelf(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func popNav(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}
