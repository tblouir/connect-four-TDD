class GameBoard
  attr_accessor :coordinate_array, :taken_coordinates, :current_player
  attr_reader :players, :rows, :columns
  def initialize(rows = 6, columns = 7)
    @players = []
    @players << Player.new('John', 'O')
    @players << Player.new('Peco', 'X')
    @current_player = @players[0]

    @rows = rows
    @columns = columns
    @coordinate_array = []
    @taken_coordinates = []
    populate_coordinates
    puts "##########"
    puts "GAME START"
    puts "##########"
    play_game
  end

  # Populate possible coordinates with [row, column]
  def populate_coordinates
    rows.times do |i|
      columns.times do |j|
        @coordinate_array << [i, j]
      end
    end
  end

  # Get coordinate with #get_coordinate, validate with #valid_spot?, add it to taken coordinates, player's positions, and rotate @current_player
  def choose_spot
    coordinate = get_coordinate

    until valid_spot?(coordinate)
      puts "Invalid selection! Please try again."
      return nil
    end

    @current_player.positions << coordinate
    @taken_coordinates << coordinate
    @current_player = @players.rotate![0]
  end

  # Prompt player with #player_input, ensures integer and one digit
  def get_coordinate
    row, column = player_input

    while row.nil? || row.digits.length > 1
      puts ''
      puts "Invalid input"
      row = player_input(nil, column)[0]
    end

    while column.nil? || column.digits.length > 1
      puts ''
      puts "Invalid input"
      column = player_input(row, nil)[1]
    end

    [row, column]
  end

  # Prompt player for integer row and column
  def player_input(row = nil, column = nil)
    if row.nil?
      puts ''
      puts "Please input Row"
      row = Integer(gets.chomp, 10, exception: false)
    end

    if column.nil?
      puts ''
      puts "Please input Column"
      column = Integer(gets.chomp, 10, exception: false)
    end

    [row, column]
  end

  # Check if spot is occupied already or spot underneath it is empty
  def valid_spot?(coordinate)
    row, column = coordinate
    row -= 1

    # Check if on board and not taken
    return false if @taken_coordinates.include?(coordinate) || !@coordinate_array.include?(coordinate)

    # Check every row underneath
    until row < 0
      unless @taken_coordinates.include?([row, column])
        return false
      end
      row -= 1
    end

    return true
  end

  # Check for win conditions
  def game_over?
    if check_row? || check_column? || check_diagonal?
      puts "#######"
      puts "The winner is #{@current_player.name}!"
      puts "#######"
      return true
    end
  end

  def check_row?
    row_hash = Hash.new(0)
    value_array = []

    @players.each do |player|
      player.positions.each do |position|
        row_hash[position[0]] += 1
      end
      
      row_hash.each_pair do |key, value|
        if value >= 4
          player.positions.each do |position|
            value_array << position[1] if position[0] == key
          end
          return true if four_in_row?(value_array)
          value_array.clear
          row_hash.delete(key)
        end
      end
    end

    return false
  end

  def four_in_row?(array)
    array.sort!.each_index do |index|
      (array.length - 3).times do
        return true if array[index] + 1 == array[index+1] && array[index+1] + 1 == array[index+2] && array[index+2] + 1 == array[index+3]
      end
    end

    return false
  end

  def check_column?
    column_hash = Hash.new(0)
    value_array = []

    @players.each do |player|
      player.positions.each do |position|
        column_hash[position[1]] += 1
      end
      
      column_hash.each_pair do |key, value|
        if value >= 4
          player.positions.each do |position|
            value_array << position[0] if position[1] == key
          end
          return true if four_in_column?(value_array)
          value_array.clear
          column_hash.delete(key)
        end
      end
    end

    return false
  end

  def four_in_column?(array)
    array.sort!.each_index do |index|
      (array.length - 3).times do
        return true if array[index] + 1 == array[index+1] && array[index+1] + 1 == array[index+2] && array[index+2] + 1 == array[index+3]
      end
    end

    return false
  end

  def check_diagonal?
    tally = 1

    @players.each do |player|
      if player.positions.length >= 4
        player.positions.each do |position|
          tally += 1 if player.positions.include?([position[0] + 1, position[1] + 1])
          tally += 1 if player.positions.include?([position[0] + 2, position[1] + 2])
          tally += 1 if player.positions.include?([position[0] + 3, position[1] + 3])
          tally += 1 if player.positions.include?([position[0] - 1, position[1] - 1])
          tally += 1 if player.positions.include?([position[0] - 2, position[1] - 2])
          tally += 1 if player.positions.include?([position[0] - 3, position[1] - 3])

          tally += 1 if player.positions.include?([position[0] + 1, position[1] - 1])
          tally += 1 if player.positions.include?([position[0] + 2, position[1] - 2])
          tally += 1 if player.positions.include?([position[0] + 3, position[1] - 3])
          tally += 1 if player.positions.include?([position[0] - 1, position[1] + 1])
          tally += 1 if player.positions.include?([position[0] - 2, position[1] + 2])
          tally += 1 if player.positions.include?([position[0] - 3, position[1] + 3])
          return true if tally >= 4
          tally = 0
        end
      end
    end

    return false
  end

  # Display taken and empty spots
  def display_board
    puts ''
    print "     "
    @columns.times do |i|
      print " C#{i}"
    end
    puts ''
    @rows.times do |i|
      print "Row #{i} "
      @columns.times do |j|
        if @taken_coordinates.include?([i, j])
          @players.each { |player| print " #{player.symbol} " if player.positions.include?([i, j]) }
        else
          print ' E '
        end
      end
      puts ''
    end
  end

  def board_full?
    return true if @taken_coordinates.length == (@rows * @columns)
    return false
  end

  # Loop until game over
  def play_game
    until game_over? || board_full?
      display_board
      choose_spot
    end
    display_board
  end

end

class Player
  attr_accessor :positions
  attr_reader :name, :symbol
  def initialize(name = 'Default', symbol = nil)
    @name = name
    @positions = []
    @symbol = symbol
  end
end

game = GameBoard.new