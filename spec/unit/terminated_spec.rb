# frozen_string_literal: true

RSpec.describe FiniteMachine, '#terminated?' do

  it "allows to specify terminal state" do
    fsm = FiniteMachine.new do
      initial :green
      terminal :red

      event :slow, :green  => :yellow
      event :stop, :yellow => :red
    end

    expect(fsm.current).to eql(:green)
    expect(fsm.terminated?).to be(false)

    fsm.slow
    expect(fsm.current).to eql(:yellow)
    expect(fsm.terminated?).to be(false)

    fsm.stop
    expect(fsm.current).to eql(:red)
    expect(fsm.terminated?).to be(true)
  end

  it "allows to specify terminal state as parameter" do
    fsm = FiniteMachine.new terminal: :red do
      initial :green

      event :slow, :green  => :yellow
      event :stop, :yellow => :red
    end
    fsm.slow
    fsm.stop
    expect(fsm.terminated?).to be(true)
  end

  it "checks without terminal state" do
    fsm = FiniteMachine.new do
      initial :green

      event :slow, :green  => :yellow
      event :stop, :yellow => :red
    end

    expect(fsm.current).to eql(:green)
    expect(fsm.terminated?).to be(false)

    fsm.slow
    expect(fsm.current).to eql(:yellow)
    expect(fsm.terminated?).to be(false)

    fsm.stop
    expect(fsm.current).to eql(:red)
    expect(fsm.terminated?).to be(false)
  end

  it "allows for multiple terminal states" do
    fsm = FiniteMachine.new do
      initial :open

      terminal :close, :canceled, :faulty

      event :resolve, :open => :close
      event :decline, :open => :canceled
      event :error,   :open => :faulty
    end
    expect(fsm.current).to eql(:open)
    expect(fsm.terminated?).to be(false)

    fsm.resolve
    expect(fsm.current).to eql(:close)
    expect(fsm.terminated?).to be(true)

    fsm.restore!(:open)
    fsm.decline
    expect(fsm.current).to eql(:canceled)
    expect(fsm.terminated?).to be(true)

    fsm.restore!(:open)
    fsm.error
    expect(fsm.current).to eql(:faulty)
    expect(fsm.terminated?).to be(true)
  end
end
