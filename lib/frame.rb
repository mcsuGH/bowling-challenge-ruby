class Frame
  attr_reader :pins_remaining

  PINS = 10

  def initialize
    @rolls = []
    @pins_remaining = PINS
  end

  def add_roll(num)
    @pins_remaining -= num
    @rolls << num
  end

  def rolls
    @rolls.length
  end

  def first_roll
    @rolls[0]
  end

  def second_roll
    @rolls[1]
  end

  def bonus_roll
    @rolls[2]
  end

  def strike?
    @rolls.length == 1 && @pins_remaining.zero?
  end

  def spare?
    @rolls.length == 2 && @pins_remaining.zero?
  end
end
