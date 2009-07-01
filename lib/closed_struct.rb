require 'ostruct'

class ClosedStruct < OpenStruct # :nodoc:
  
  def initialize(*args)
    if args.length == 1
      super(args.first)
    else
      h = args.inject({}){ |memo, k| memo[k] = nil; memo }
      super(h)
    end
    @closed = true
  end
  
  def new_ostruct_member(name)
    if @closed
      raise RuntimeError, "cannot add members to closed struct"
    else
      super
    end
  end
  
  def method_missing(name, *args)
    raise NoMethodError, "undefined method '#{name}' for #{self}"
  end
  
  def id
    if @table.has_key?(:id)
      @table[:id]
    else
      method_missing(:id)
    end
  end
  
  def to_h
    @table.dup
  end
  
end