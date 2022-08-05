import Foundation
import UIKit

class NewsCell: UITableViewCell {
  
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
  func configure(text: String, author: String, image: UIImage?, date: String) {
    if let data = image?.jpeg(.lowest),
       let img = UIImage(data: data)
    {
      _imageView.image = resizeImage(image: img, width: 320)
    }
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
