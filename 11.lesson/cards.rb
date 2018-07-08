# frozen_string_literal: true

# module Cards
class Cards
  attr_reader :score_weight

  def initialize
    @deck_count = 2 # user get 2 cards
    @spades =   %w[1F0A1 1F0A2 1F0A3 1F0A4 1F0A5 1F0A6 1F0A7 1F0A8 1F0A9 1F0AA 1F0AB 1F0AD 1F0AE]
    @hearts =   %w[1F0B1 1F0B2 1F0B3 1F0B4 1F0B5 1F0B6 1F0B7 1F0B8 1F0B9 1F0BA 1F0BB 1F0BD 1F0BE]
    @diamonds = %w[1F0C1 1F0C2 1F0C3 1F0C4 1F0C5 1F0C6 1F0C7 1F0C8 1F0C9 1F0CA 1F0CB 1F0CD 1F0CE]
    @clubs    = %w[1F0D1 1F0D2 1F0D3 1F0D4 1F0D5 1F0D6 1F0D7 1F0D8 1F0D9 1F0DA 1F0DB 1F0DD 1F0DE]
    @score_weight = 0
  end

  def full_deck
    deck = @spades + @hearts + @diamonds + @clubs
    deck.shuffle
  end

  def getting_whole_deck
    @full_deck = @spades + @hearts + @diamonds + @clubs
  end

  def random_cards
    @random_cards = full_deck.sample(@deck_count)
  end

  def random_cards_print
    @random_cards = full_deck.sample(@deck_count).each do |card|
      print [card.hex].pack('U*') + ', '
    end
  end

  def show_all_cards
    puts_cards_symbols(@spades)
    puts_cards_symbols(@hearts)
    puts_cards_symbols(@diamonds)
    puts_cards_symbols(@clubs)
  end

  def puts_cards_symbols(line)
    line.each { |card| print [card.hex].pack('U*') + ', ' }
    new_line
  end

  def puts_card_symbol(card)
    print [card.hex].pack('U*') + ', '
  end

  def score_calculate(cards)
    @score_weight = 0
    @sorted_cards = []

    cards.each do |element|
      picture_card ||= nil
      nummeric_card ||= nil

      if %w[A B D E].include?(element[4..4])
        picture_card = element
      else
        nummeric_card = element
      end

      if nummeric_card.nil?
        if @sorted_cards[0].nil?
          @sorted_cards[0] = picture_card
        else
          @sorted_cards[1] = picture_card
        end
      elsif picture_card.nil?
        if @sorted_cards[0].nil?
          @sorted_cards[0] = nummeric_card
        else
          @sorted_cards[1] = nummeric_card
        end
      else
        @sorted_cards = [picture_card, nummeric_card]
      end
    end

    @sorted_cards = @sorted_cards.reverse if @sorted_cards[0][4..4] == '1'

    @sorted_cards.each do |card|
      string = card[4..4]

      if string.match? /^[a-z]+$/i
        @score_weight += 10
      else
        case string.to_i
        when 2..10
          @score_weight += string.to_i
        when 1
          if ((21 - (@score_weight + 1)) < (21 - (@score_weight + 11)) && (@score_weight + 11 <  21)) || @score_weight.zero?
            @score_weight += 1
          else
            @score_weight += 11
          end
        end
      end
    end
    @score_weight
  end

  def new_line
    puts "\n \n"
  end

  def new_half_line
    puts "\n"
  end

  def do_line
    puts BORDERLINE
  end
end
