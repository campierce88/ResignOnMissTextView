//
//  ResignOnMissTextView.swift
//  ResignOnMissTextView
//
//  Created by Cameron Pierce on 2/29/16.
//  Copyright © 2016 Cameron Pierce. All rights reserved.
//

public protocol ResignOnMissTextViewDelegate {
    func shouldResignOnMiss(_ textView: ResignOnMissTextView) -> Bool
}

public let NotificationWindowTapped = "notificationWindowTapped"

public class ResignOnMissTextView: UITextView {

    public var placeholder: String?
    public var placeholderColor: UIColor = .lightGray
    var placeholderLabel: UILabel
    var accessoryView: UIView?
    public var dismissDelegate: ResignOnMissTextViewDelegate?

    override public var textContainerInset: UIEdgeInsets {
        get {
            return super.textContainerInset
        }
        set {
            super.textContainerInset = newValue

            placeholderLabel.frame = CGRect(x: newValue.left + 3.0, y: 8.0, width: bounds.size.width - (newValue.left - newValue.right), height: 0.0)
        }
    }

    fileprivate let UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.0
    fileprivate let UI_PLACEHOLDER_LABEL_TAG = 999

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        placeholderLabel = UILabel.init(frame: frame)
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        placeholderLabel = UILabel.init(coder: aDecoder)!
        super.init(coder: aDecoder)
        commonInit()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {

        placeholderLabel = UILabel.init(frame: CGRect(x: 3.5, y: 8.0, width: bounds.size.width - 7, height: 0.0))
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = font
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.textColor = placeholderColor

        placeholderLabel.alpha = 0
        placeholderLabel.tag = UI_PLACEHOLDER_LABEL_TAG
        addSubview(placeholderLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(windowTapNotificationReceived(_:)), name: NSNotification.Name(rawValue: NotificationWindowTapped), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public var text: String! {
        didSet {
            textChanged()
        }
    }

    override public func draw(_ rect: CGRect) {
        if (!(placeholder ?? "").isEmpty) {
            placeholderLabel.textColor = placeholderColor
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
            sendSubview(toBack: placeholderLabel)
        }

        if ((text ?? "").isEmpty && !(placeholder ?? "").isEmpty)  {
            viewWithTag(UI_PLACEHOLDER_LABEL_TAG)?.alpha = 1
        }

        super.draw(rect)
    }

    func windowTapNotificationReceived(_ notification: Notification) {
        if let view = notification.object as? UIView {
            if (self.isFirstResponder &&
                view != self &&
                view != accessoryView &&
                view.superview != accessoryView &&
                String(describing: type(of: view)) != "UIAutocorrectInlinePrompt")
            {

                if self.dismissDelegate != nil {
                    if dismissDelegate!.shouldResignOnMiss(self) {
                        self.resignFirstResponder()
                    }
                } else {
                    self.resignFirstResponder()
                }
            }
        }
    }

    func textChanged(_ notification: Notification? = nil) {
        if (!(placeholder ?? "").isEmpty) {
            UIView.animate(withDuration: UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION, animations: { () -> Void in
                if ((self.text ?? "").isEmpty) {
                    self.viewWithTag(self.UI_PLACEHOLDER_LABEL_TAG)?.alpha = 1.0
                } else {
                    self.viewWithTag(self.UI_PLACEHOLDER_LABEL_TAG)?.alpha = 0.0
                }
            })
        } else {
            return
        }
    }
}
