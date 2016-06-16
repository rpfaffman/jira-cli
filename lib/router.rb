class Router
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def process(args, options={})
    case (args[0] && args[0].downcase)
    when "update"
      app.public_send(:update, args[1], options)
    when "transition"
      app.public_send(:transition, args[1], options)
    else # default to query
      args = options.any? ? options : args[0]
      app.public_send(:query, args)
    end
  end
end
