import UIKit

public class NewsViewHstack: UIView {
  
  // MARK: Properties
  private var didSetupConstraints = false
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView(frame: .zero)
    scrollView.backgroundColor = .clear
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.layoutMargins = .zero
    return scrollView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 18
    return stackView
  }()
  
  // MARK: Life Cycle
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    setNeedsUpdateConstraints()
  }
  
  public override func updateConstraints() {
    super.updateConstraints()
    if !didSetupConstraints {
      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.2),
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
      ])
      didSetupConstraints.toggle()
    }
  }
  
}

// MARK: - ScrollableStackView - Actions
extension NewsViewHstack {
  
  public func add(view: UIView) {
    stackView.addArrangedSubview(view)
  }
  
  public func insert(view: UIView, at index:  Int) {
    stackView.insertArrangedSubview(view, at: index)
  }
  
  
  public func remove(view: UIView) {
    stackView.removeArrangedSubview(view)
  }
}


extension NewsViewHstack {
  
  public var spacing: CGFloat {
    get {
      return stackView.spacing
    }
    set {
      stackView.spacing = newValue
    }
  }
  
  
  public var alignment: UIStackView.Alignment {
    get {
      return stackView.alignment
    }
    set {
      stackView.alignment = newValue
    }
  }
  
  
  public var distribution: UIStackView.Distribution {
    get {
      return stackView.distribution
    }
    set {
      stackView.distribution = newValue
    }
  }
  
  
  public var showsHorizontalScrollIndicator: Bool {
    get {
      return scrollView.showsHorizontalScrollIndicator
    }
    set {
      scrollView.showsHorizontalScrollIndicator = newValue
    }
  }
  
  public var showsVerticalScrollIndicator: Bool {
    get {
      return scrollView.showsVerticalScrollIndicator
    }
    set {
      scrollView.showsHorizontalScrollIndicator = newValue
    }
  }
  
  
  public var bounces: Bool {
    get {
      return scrollView.bounces
    }
    set {
      scrollView.bounces = newValue
    }
  }
}
