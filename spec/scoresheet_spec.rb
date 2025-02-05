require 'scoresheet'

describe Scoresheet do
  let(:scoresheet) { described_class.new }

  it 'Should create a new frame once there are 2 rolls in a frame' do
    scoresheet.current_frame.add_roll(5)
    scoresheet.current_frame.add_roll(2)
    expect(scoresheet).to receive(:new_frame)
    scoresheet.current_frame.add_roll(2)
  end

  it 'Should create a new frame if there are no pins left before the second roll' do
    scoresheet.current_frame.add_roll(10)
    expect(scoresheet).to receive(:new_frame)
    scoresheet.current_frame.add_roll(2)
  end

  describe '#total_score' do
    it 'Should be able to get a total score after the tenth frame has ended' do
      20.times do
        scoresheet.current_frame.add_roll(0)
      end
      expect(scoresheet.total_score).to eq(0)
    end

    it 'Does not give a total score until the game is complete' do
      scoresheet.current_frame.add_roll(10)
      expect { scoresheet.total_score }.to raise_error('Your game has not finished yet!')
    end
  end

  describe '#frame_score' do
    it 'Should calculate the score of a frame' do
      scoresheet.current_frame.add_roll(6)
      scoresheet.current_frame.add_roll(2)
      scoresheet.current_frame.add_roll(2) # extra roll to create a new frame
      expect(scoresheet.frame_score(1)).to eq(8)
    end
  end

  describe '#strike_bonus' do
    it 'Should add the value of the next two rolls as a bonus after rolling a strike' do
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(6)
      scoresheet.current_frame.add_roll(2)
      scoresheet.current_frame.add_roll(2) # extra roll to create a new frame
      expect(scoresheet.frame_score(1)).to eq(18)
    end

    it 'Should add the value of the next two rolls even if from different frames as a bonus after rolling a strike' do
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(2) # extra roll to create a new frame
      expect(scoresheet.frame_score(1)).to eq(30)
    end
  end

  describe '#spare_bonus' do
    it 'Should add the value of the next roll as a bonus after rolling a spare' do
      scoresheet.current_frame.add_roll(8)
      scoresheet.current_frame.add_roll(2)
      scoresheet.current_frame.add_roll(2)
      scoresheet.current_frame.add_roll(2) # extra rolls to create a new frame
      scoresheet.current_frame.add_roll(2) # extra rolls to create a new frame
      expect(scoresheet.frame_score(1)).to eq(12)
    end
  end

  context 'Tenth Frame' do
    it 'Should let the last frame have upto 3 rolls if a spare is landed' do
      18.times do
        scoresheet.current_frame.add_roll(0)
      end
      scoresheet.current_frame.add_roll(8)
      scoresheet.current_frame.add_roll(2)
      expect(scoresheet.complete?).to_not eq(true)
      scoresheet.current_frame.add_roll(7)
      scoresheet.current_frame
      expect(scoresheet.complete?).to eq(true)
    end

    it 'Should let the last frame to have upto 3 rolls if a strike is landed' do
      18.times do
        scoresheet.current_frame.add_roll(0)
      end
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(10)
      expect(scoresheet.complete?).to_not eq(true)
      scoresheet.current_frame.add_roll(7)
      scoresheet.current_frame
      expect(scoresheet.complete?).to eq(true)
    end

    it 'Should only add the bonus of the extra roll to score' do
      18.times do
        scoresheet.current_frame.add_roll(0)
      end
      scoresheet.current_frame.add_roll(8)
      scoresheet.current_frame.add_roll(2)
      scoresheet.current_frame.add_roll(7)
      expect(scoresheet.total_score).to eq(17)
    end

    it 'Should only add the bonus of the extra rolls to score' do
      18.times do
        scoresheet.current_frame.add_roll(0)
      end
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(10)
      scoresheet.current_frame.add_roll(7)
      expect(scoresheet.total_score).to eq(27)
    end
  end

  context 'Edge Cases' do
    it 'if 9th and 10th frames are strikes, then 9th will take also the second roll of 10th frame as bonus' do
      16.times do
        scoresheet.current_frame.add_roll(0)
      end
      scoresheet.current_frame.add_roll(10) # 9th frame
      scoresheet.current_frame.add_roll(10) # 10th frame
      scoresheet.current_frame.add_roll(10) # 10th frame
      scoresheet.current_frame.add_roll(7) # 10th frame
      scoresheet.current_frame
      expect(scoresheet.frame_score(9)).to eq(30)
    end

    it 'perfect game of 12 strikes' do
      12.times do
        scoresheet.current_frame.add_roll(10)
      end
      expect(scoresheet.total_score).to eq(300)
    end

    it 'gutter game of 20 gutters' do
      20.times do
        scoresheet.current_frame.add_roll(0)
      end
      expect(scoresheet.total_score).to eq(0)
    end
  end
end
