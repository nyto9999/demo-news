import Foundation
import UIKit

class NewsCellView: UITableViewCell {
  static let id = "newscell"
  
  private var _titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var _authorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }
  private func setupViews() {
    contentView.addSubview(_titleLabel)
    contentView.addSubview(_authorLabel)
    contentView.addSubview(_dateLabel)
  }
  
  
  private func setupConstraints() {
    let marginGuide = contentView.layoutMarginsGuide
    
    //title
    _titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    _titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    
    //author
    _authorLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor).isActive = true
    _authorLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _authorLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    
    
    //date
    _dateLabel.topAnchor.constraint(equalTo: _authorLabel.bottomAnchor).isActive = true
    _dateLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _dateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    _dateLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
  }
   
  func configure(text: String, author: String, date: String) {
    _titleLabel.text   = text
    _authorLabel.text  = author
    _dateLabel.text    = date
    
  }
  
  override func prepareForReuse() {
    _titleLabel.text  = nil
    _authorLabel.text = nil
    _dateLabel.text   = nil
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
