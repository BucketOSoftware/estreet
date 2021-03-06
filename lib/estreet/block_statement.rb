module Estreet
  class BlockStatement < Statement
    def initialize(*statements)
      @statements = statements.map do |st|
        st.to_statement
        # raise TypeError, "Not a statement: #{st}" unless st.is_a? Statement
      end
    end

    def attributes
      super.merge(body: @statements)
    end

    def to_block
      self
    end

    # Add another statement to the end of the receiver block
    def <<(statement)
      self.class.flatten(self, statement)
    end
    
    def self.flatten(*statements)
      new(*statements.flat_map do |stmt|
        if stmt.is_a? self
          stmt.statements
        else
          stmt.to_statement
        end
      end)
    rescue NoMethodError => e
      raise TypeError, "Can't convert to statement: #{statements.inspect}"
    end
    
    attr_reader :statements
  end
end