require './game.rb'

describe GameBoard do
  
  describe '#populate_coordinates' do
    subject(:board) { described_class.new }

    context 'Given a number of rows and columns' do
      it 'Returns array of coordinates with length equal area of rows and columns' do
        coordinate_array = board.coordinate_array
        rows = board.rows
        columns = board.columns
        expect(coordinate_array.length).to eq(rows*columns)
      end
    end
  end

  describe '#valid_spot?' do
    subject(:board) { described_class.new }

    before do
      board.taken_coordinates << [0, 0]
      board.taken_coordinates << [1, 0]
      board.taken_coordinates << [2, 0]
    end

    context 'Given a coordinate with an empty spot underneath it' do
      it 'returns false' do
        coordinate = [5, 0]
        result = board.valid_spot?(coordinate)
        expect(result).to be(false)
      end
    end
    
    context 'Given a valid coordinate' do
      it 'returns true' do
        coordinate = [3, 0]
        result = board.valid_spot?(coordinate)
        expect(result).to be(true)
      end
    end
  end

  describe '#choose_spot' do
    subject(:board) { described_class.new }
    let(:player) { Player.new('Tester') }

    context 'When choosing a spot' do
      it 'pushes coordinate to player positions and taken coordinates' do
        allow(board).to receive(:get_coordinate).and_return([0,0])
        board.current_player = player
        board.choose_spot
        expect(player.positions).to include([0,0])
        expect(board.taken_coordinates).to include([0,0])
      end
    end
  end

  describe '#get_coordinate' do
    let(:board) { described_class.new }

    context 'When user inputs two incorrect values, then a valid input' do
      before do
        valid = [0,0]
        invalid = [nil, 0]
        allow(board).to receive(:player_input).and_return(invalid, invalid, valid)
      end

      it 'displays error message twice and returns successfully' do
        expect(board).to receive(:puts).with("Invalid input").twice
        board.get_coordinate
      end
    end
  end

  describe '#play_game' do
    context '' do
      xit '' do
        expect()
      end
    end
  end

end