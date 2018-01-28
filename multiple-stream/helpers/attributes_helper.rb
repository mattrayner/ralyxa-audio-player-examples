class AttributesHelper
  attr_accessor :loop, :shuffle, :index, :play_order, :offset_in_milliseconds

  def initialize(attributes)
    attributes ||= {}

    @loop                   = attributes['loop']                 || false
    @shuffle                = attributes['shuffle']              || false
    @index                  = attributes['index']                || 0
    @play_order             = attributes['playOrder']            || AttributesHelper.standard_play_order
    @offset_in_milliseconds = attributes['offsetInMilliseconds'] || 0
  end

  def to_hash
    {}.tap do |attributes|
      attributes['loop']                 = @loop
      attributes['shuffle']              = @shuffle
      attributes['index']                = @index
      attributes['playOrder']            = @play_order
      attributes['offsetInMilliseconds'] = @offset_in_milliseconds
    end
  end

  def to_json
    to_hash.to_json
  end

  def self.standard_play_order
    Array.new(AudioData::STREAMS.length) { |i| i }
  end

  def self.shuffled_play_order
    standard_play_order.shuffle!
  end
end