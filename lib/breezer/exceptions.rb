# frozen_string_literal: true

# Thrown when we can't find a Gemfile
class NoGemfileException < StandardError
  def initialize(msg = 'Unable to find a Gemfile')
    super
  end
end

# Thrown when we can't find a Lockfile (Gemfile.lock)
class NoLockfileException < StandardError
  def initialize(msg = 'Unable to find a Lockfile')
    super
  end
end

# Thrown the supplied level is invalid
class InvalidLevelException < StandardError
  def initialize(msg = "Error: level must be one of: 'major', 'minor', 'patch' or 'exact'")
    super
  end
end
