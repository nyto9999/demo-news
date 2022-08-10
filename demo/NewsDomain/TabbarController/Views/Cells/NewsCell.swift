import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
  // MARK: Layouts
  private var _titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
    label.textColor = .darkText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _authorLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _imageView: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .clear
    image.layer.cornerRadius = 7
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private var _dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
    
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[author]-[title]-[image]-[date]-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[title]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[author]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[image]-(10)-|", options: [], metrics: nil, views: vd))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[date]-(10)-|", options: [], metrics: nil, views: vd))
  }
  
  // MARK: Methods
  func configure(text: String, author: String, image: UIImage?, date: String) {
    
    _imageView.image   = image?.withRoundedCorners(radius: 7)
    _titleLabel.text   = text
    _authorLabel.text  = author
    _dateLabel.text    = date
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

