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
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    _setupViews()
    _setupConstraints()
  }
  private func _setupViews() {
    contentView.addSubview(_titleLabel)
    contentView.addSubview(_authorLabel)
    contentView.addSubview(_imageView)
    contentView.addSubview(_dateLabel)
  }
  
  
  private func _setupConstraints() {
    let marginGuide = contentView.layoutMarginsGuide
    
    //title
    _titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    _titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    
    //author
    _authorLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor).isActive = true
    _authorLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _authorLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    
    //imageview
    _imageView.topAnchor.constraint(equalTo: _authorLabel.bottomAnchor).isActive = true
    _imageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _imageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    
    //date
    _dateLabel.topAnchor.constraint(equalTo: _imageView.bottomAnchor).isActive = true
    _dateLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    _dateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    _dateLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
  }
  
  func configure(text: String, author: String, data: Data, date: String) {
    _titleLabel.text   = text
    _authorLabel.text  = author
    
    
    
    
    if let compressedData = UIImage(data: data)?.jpeg(.lowest),
       let compressedImg  = UIImage(data: compressedData)
    {
      
      _imageView.image = _resizeImage(image: compressedImg, width: 320)
//      print("compressedData \(compressedData.count), originData \(data)")
      
    }
    
    
    _dateLabel.text    = date
  }
  
  private func _resizeImage(image: UIImage, width: CGFloat) -> UIImage {
    let size = CGSize(width: width, height:
                        image.size.height * width / image.size.width)
    let renderer = UIGraphicsImageRenderer(size: size)
    let newImage = renderer.image { (context) in
      image.draw(in: renderer.format.bounds)
    }
    return newImage
  }
  
  override func prepareForReuse() {
    _titleLabel.text  = nil
    _authorLabel.text = nil
    _dateLabel.text   = nil
    _imageView.image   = UIImage(systemName: "circle")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
