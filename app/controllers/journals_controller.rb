class JournalsController < ApplicationController

  def create
    pet.journalize!(pet.shelter, pet.pet_state)
  end
  
end
