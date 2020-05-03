# encoding : utf-8

MoneyRails.configure do |config|

  # To set the default currency
  config.default_currency = :usd

  # Set default bank object
  # config.default_bank = EuCentralBank.new
  # set default bank to instance of GoogleCurrency
  # Money::Bank::GoogleCurrency.ttl_in_seconds = 86400
  # config.default_bank = Money::Bank::GoogleCurrency.new

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # Register a custom currency
  # config.register_currency = {
  #   priority:            1,
  #   iso_code:            "EU4",
  #   name:                "Euro with subunit of 4 digits",
  #   symbol:              "€",
  #   symbol_first:        true,
  #   subunit:             "Subcent",
  #   subunit_to_unit:     10000,
  #   thousands_separator: ".",
  #   decimal_mark:        ","
  # }

  # Specify a rounding mode
  # set to BigDecimal::ROUND_HALF_EVEN by default
  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Set default money format globally.
  # Default value is nil meaning "ignore this option".
  # config.default_format = {
  #   no_cents_if_whole: nil,
  #   symbol: nil,
  #   sign_before_symbol: nil
  # }

  # config.locale_backend = :i18n
  # config.locale_backend = :currency
  config.locale_backend = nil

  # config.raise_error_on_money_parsing = false
end
