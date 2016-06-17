class Router
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def process(args, options={})
    command_str = args[0] && args[0].downcase

    if accepted_commands.include?(command_str)
      additional_args = options.any? ? options : args[2..-1]
      app.public_send(args[0], args[1], additional_args)
    else
      app.query(options.any? ? options : args[0])
    end
  end

  private

  def accepted_commands
    [
      "update",
      "transition",
      "open"
    ]
  end
end
