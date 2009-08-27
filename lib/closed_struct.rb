require 'ostruct'

# Like OpenStruct, but raises an exception if you try to access a member that wasn't specified in the initializer.
class ClosedStruct < OpenStruct
  
  def self.r_new(hash)
    closed_struct = ClosedStruct.new(hash)
    closed_struct.send(:recursive_initialize)
    closed_struct
  end
  
  def initialize(*args)
    if args.length == 1 and args.first.kind_of?(Hash)
      super(args.first)
    elsif args.length > 1 and args.all?{ |arg| [Symbol, String].include?(arg.class) }
      args = args.inject({}){ |memo, arg| memo[arg.to_sym] = nil; memo }
      super(args)
    else
      raise ArgumentError, "invalid arguments: #{args.inspect}"
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
  
private
  
  def recursive_initialize
    @table.each do |k, v|
      if v.kind_of?(Hash)
        @table[k] = ClosedStruct.r_new(v)
      elsif v.kind_of?(Array)
        @table[k] = v.collect{ |e| e.kind_of?(Hash) ? ClosedStruct.r_new(e) : e }
      end
    end
  end
  
end
