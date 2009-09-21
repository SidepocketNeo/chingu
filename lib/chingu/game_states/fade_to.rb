#--
#
# Chingu -- Game framework built on top of the opengl accelerated gamelib Gosu
# Copyright (C) 2009 ippa / ippa@rubylicio.us
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#++


#
# Premade game state for chingu - Fade between two game states
# Fade from the current game state to a new one whenever with: 
#
#   push_game_state(Chingu::GameStates::FadeTo.new(new_game_state, :speed => 3))
#
# .. Or make your whole game look better with 1 line:
#
#   transitional_game_state(Chingu::GameStates::FadeTo, :speed => 10)
#
module Chingu
  module GameStates
    class FadeTo < Chingu::GameState
      def initialize(new_game_state, options = {})
        @options = {:speed => 3}.merge(options)
        @new_game_state = new_game_state        
      end
    
      def setup
        @color = Gosu::Color.new(0,0,0,0)
        @alpha = 0.0
        @fading_in = false
        @new_game_state.update      # Make sure states game logic is run Once (for a correct draw())
      end
    
      def update
        @alpha += (@fading_in ? -@options[:speed] : @options[:speed])
        if @alpha >= 255
          @fading_in = true
        else
          @color.alpha = @alpha.to_i
        end
        @drawn = false
      end
      
      def draw
        # Stop endless loops
        if @drawn == false
          @drawn = true
          @game_state_manager.previous_game_state.draw  if @fading_in == false
          @new_game_state.draw                          if @fading_in == true
      
          $window.draw_quad( 0,0,@color,
                              $window.width,0,@color,
                              $window.width,$window.height,@color,
                              0,$window.height,@color,999)
                          
          if @fading_in == true && @alpha == 0
            @game_state_manager.switch_game_state(@new_game_state, :transitional => false)
          end
        end
      end
    end
  end
end