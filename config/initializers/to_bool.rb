class String
  # Taken from https://gist.github.com/ChuckJHardySnippets/2000623
  def to_bool
    return true  if self == true  || self =~ (/^(true|t|yes|y|enabled|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|disabled|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
