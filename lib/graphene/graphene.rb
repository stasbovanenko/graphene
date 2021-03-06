module Graphene
  # Class for Graphene Exceptions
  class GrapheneException < StandardError; end

  # For the given resources, returns the share of the count that each attr(s) has.
  # 
  # "resources" is an array of objects which responds to the "args" method(s).
  # 
  # "args" is one or more method symbols or proc/lambda which each object in "resources" responds to. 
  # Subtotals will be calculated from the returned values.
  # 
  # Returns an instance of Graphene::Subtotals, which implements Enumerable. Each member is
  # an array of [attribute(s), count]
  # 
  # Example, Browser Family share:
  # 
  #  Graphene.subtotals(logins, :browser_family).to_a
  #  => [['Firefox', 5040], ['Chrome', 1960], ['Internet Explorer', 1500], ['Safari', 1000], ['Unknown', 500]]
  # 
  # Example, Browser/OS share, asking for symbols back:
  # 
  #  Graphene.subtotals(server_log_entries, :browser_sym, :os_sym).to_a
  #  => [[:firefox, :windows_7, 50.4, 5040], [:chrome, :osx, 19.6, 1960], [:msie, :windows_xp, 15, 1500], [:safari, :osx, 10, 1000], [:other, :other, 5, 100]]
  #
  def self.subtotals(resources, *args)
    Subtotals.new(resources, *args)
  end

  # For the given "resources", returns the % share of the group that each attr(s) has.
  # 
  # "resources" is an array of objects which responds to the "args" method(s).
  # 
  # "args" is one or more method symbols or proc/lambda which each object in "resources" responds to. 
  # Percentages will be calculated from the returned values.
  # 
  # "args" may have, as it's last member, :threshold => n, where n is the number of the lowest
  # percentage you want returned.
  # 
  # Returns an instance of Graphene::Percentages, which implements Enumerable. Each member is
  # an array of [attribute(s), percentage]
  # 
  # Example, Browser Family share:
  # 
  #  Graphene.percentages(logins, :browser_family).to_a
  #  => [['Firefox', 50.4], ['Chrome', 19.6], ['Internet Explorer', 15], ['Safari', 10], ['Unknown', 5]]
  # 
  # Example, Browser/OS share, asking for symbols back:
  # 
  #  Graphene.percentages(server_log_entries, :browser_sym, :os_sym).to_a
  #  => [[:firefox, :windows_7, 50.4], [:chrome, :osx, 19.6], [:msie, :windows_xp, 15], [:safari, :osx, 10], [:other, :other, 5]]
  #
  def self.percentages(resources, *args)
    Percentages.new(resources, *args)
  end
end
