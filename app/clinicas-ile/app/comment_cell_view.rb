class JDDCommentCellView < UITableViewCell


	def initWithStyle(viewCellStyleDefault, reuseIdentifier: reuseIdentifier)
		super
	end



	def hasViews
		!self.contentView.subviews.empty?
	end



	def set_information(title, text, user)
		title_label = create_label (
			title,
			UIColor.darkGrayColor,
			UIFont.boldSystemFontOfSize(13),
			UITextAlignmentLeft,
			contentView.bounds.origin.x + 10,
			5,
			15
		)

		text_label = create_label (
			text,
			UIColor.blackColor,
			UIFont.systemFontOfSize(12),
			UITextAlignmentLeft,
			self.contentView.bounds.origin.x + 20,
			title_label.bounds.size.height + title_label.frame.origin.x + 5,
			30
		)

		user_label = create_label (
			user,
			UIColor.lightGrayColor,
			UIFont.systemFontOfSize(10),
			UITextAlignmentRight,
			contentView.bounds.origin.x + 10,
			text_label.bounds.size.height + text_label.frame.origin.x + 10,
			10
		)

		text_label.lineBreakMode = UILineBreakModeWordWrap
		text_label.numberOfLines = 2

		self.contentView.addSubview title_label
		self.contentView.addSubview text_label
		self.contentView.addSubview user_label
	end



	def create_label (text, color, font, alignment, x, y, height)
      label = UILabel.alloc.init
      label.frame = CGRectMake(x, y, self.frame.size.width - (x * 2), height)
      label.textAlignment = alignment
      label.textColor = color
      label.font = font
      label.text = text

      label
	end

end