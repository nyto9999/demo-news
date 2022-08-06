import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
  let processor = RoundCornerImageProcessor(cornerRadius: 18)
  // MARK: Layouts
  private var _titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _authorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _imageView: UIImageView = {
    let image = UIImageView()
    image.sizeToFit()
    image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.7).isActive = true
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private var _dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: Life Cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    _setupViews()
    _setupConstraints()
    
  }
  
  // MARK: UI
  private func _setupViews() {
    contentView.addSubview(_titleLabel)
    contentView.addSubview(_authorLabel)
    contentView.addSubview(_imageView)
    contentView.addSubview(_dateLabel)
  }
  private func _setupConstraints() {
    let vd = [
      "title" : _titleLabel,
      "author": _authorLabel,
      "image" : _imageView,
      "date"  : _dateLabel]
    
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-[author]-[image]-[date]-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[title]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[author]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[image]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[date]-(10)-|", options: [], metrics: nil, views: vd))
  }
  
  // MARK: Methods
  func configure(text: String, author: String, key: String?, date: String) {
    
    if let key = key {
      ImageCache.default.isCached(forKey: key) ?
      _getCachedImage(key: key) :
      _fetchImage(key: key)
    }
    
    _titleLabel.text   = text
    _authorLabel.text  = author
    _dateLabel.text    = date
    
  }
  
  private func _getCachedImage(key: String) {
    
    ImageCache.default.retrieveImage(
      forKey: key,
      completionHandler: { result in
        switch result {
          case .success(let cached):
            print("cached")
            self._imageView.image = cached.image
          case .failure(let error):
            print(error)
        }
      })
  }
  
  private func _fetchImage(key: String) {
    guard let url = URL(string: key) else { return }
    
    let resource = ImageResource(downloadURL: url, cacheKey: key)
    self._imageView.kf.indicatorType = .activity
    self._imageView.kf.setImage(
      with: resource,
      options: [.processor(processor)],
      completionHandler: { result in
        switch result {
          case .success(let result):
            print("fetching")
            guard let data = result.image.jpeg(.lowest),
                  let img = UIImage(data: data)
            else { return }
            self._imageView.image = img
          case .failure(let error):
            print(error)
        }
      })
  }
  
  
  override func prepareForReuse() {
    _titleLabel.text  = nil
    _authorLabel.text = nil
    _dateLabel.text   = nil
    _imageView.image  = nil
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  static let id = "cell"
}
