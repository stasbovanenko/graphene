module Graphene
  # A generic class for Graphene stat result sets, which implements Enumerable and Graphene::LazyEnumerable.
  # Calculations are performed lazily, so ResultSet objects are *cheap to create, but not necessarily cheap to use*.
  class ResultSet
    include LazyEnumerable
    include Tablize
    include OneDGraphs

    # The options Hash passed in the constructor
    attr_reader :options
    # The attribute(s) that are being statted, passed in the constructor
    attr_reader :attributes
    # The original array of objects from which the stats were generated
    attr_reader :resources

    # Accepts an array of objects, and an unlimited number of method symbols (which sould be methods in the objects).
    # Optionally accepts an options hash as a last argument.
    #
    # Implements Enumerable, so the results can be accessed by any of those methods, including each and to_a.
    def initialize(resources, *args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @attributes = args
      @resources = resources
      @results = []
    end

    # Calculates the resources, gropuing them by "over_x", which can be a method symbol or lambda
    # 
    # Example by date
    # 
    #  Graphene.percentages(logs, :browser).over(:date)
    #  => {#<Date: 2012-07-22> => [["Firefox", 45], ["Chrome", 40], ["Internet Explorer", 15]],
    #      #<Date: 2012-07-23> => [["Firefox", 41], ["Chrome", 40], ["Internet Explorer", 19]],
    #      #<Date: 2012-07-24> => [["Chrome", 50], ["Firefox", 40], ["Internet Explorer", 10]]}
    #
    def over(over_x)
      OverX.new(self, over_x)
    end

    # Returns a string representation of the results
    def to_s
      to_a.to_s
    end

    # Returns the maximum result
    def max_result
      x = attributes.size
      sort_by { |result| result[x] }.last[x]
    end

    private

    # Change it to another ResultSet subclass
    def transmogrify(klass, opts=nil)
      opts ||= self.options
      klass.new(resources, *attributes, opts)
    end
  end
end
