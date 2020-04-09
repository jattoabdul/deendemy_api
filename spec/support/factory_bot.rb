require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

if defined?(FactoryBot)
  module FactoryBot::Analytics
    def self.track_factories
      @factory_bot_results = {}

      ActiveSupport::Notifications.subscribe('factory_bot.run_factory') do |_name, _start, _finish, _id, payload|
        # puts "#{ModelName.unscoped.count} - #{payload[:name]}" if payload[:strategy] == :create
        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        @factory_bot_results[factory_name] ||= {}
        @factory_bot_results[factory_name][strategy_name] ||= 0
        @factory_bot_results[factory_name][strategy_name] += 1
      end
    end

    def self.print_statistics
      return nil unless ENV['TRACK_FACTORIES'] && (@factory_bot_results.present? && @factory_bot_results.any?)

      puts "\nFactory Bot Run Results.. [strategies per factory]:"
      rows = @factory_bot_results.map { |r| [r.first, r.last.fetch(:create, 0), r.last.fetch(:build, 0), r.last.fetch(:build_stubbed, 0)] }
      rows = rows.sort_by { |t| [t[1], t[3]] }.reverse

      table = Terminal::Table.new headings: %w(Factory Created Built Stubbed), rows: rows
      table.align_column(0, :right)
      table.align_column(1, :center)
      table.align_column(2, :center)
      table.align_column(3, :center)

      puts table
    end
  end
end
