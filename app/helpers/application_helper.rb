module ApplicationHelper
  def inclusive_pluralize(count, noun, inclusive_appending)
    # if count != 0
      count == 1 ? noun.to_s : "#{noun}#{inclusive_appending}"
    # end
  end
end

# inclusive_pluralize(@referents.count, 'referent.e', '.s')
