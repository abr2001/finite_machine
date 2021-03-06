# frozen_string_literal: true

RSpec.describe FiniteMachine, '#states' do
  it "retrieves all available states" do
    fsm = FiniteMachine.new do
      initial :green

      event :slow,  :green  => :yellow
      event :stop,  :yellow => :red
      event :ready, :red    => :yellow
      event :go,    :yellow => :green
    end

    expect(fsm.states).to match_array([:none, :green, :yellow, :red])
  end

  it "retrieves all unique states for choice transition" do
    fsm = FiniteMachine.new do
      initial :green

      event :next, from: :green do
        choice :yellow, if: -> { false }
        choice :red,    if: -> { true }
      end
    end
    expect(fsm.states).to match_array([:none, :green, :yellow, :red])
  end
end
