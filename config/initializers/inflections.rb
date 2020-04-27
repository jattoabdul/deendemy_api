# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Payment processors
  inflect.irregular 'stripe', 'stripe'
  inflect.irregular 'paypal', 'paypal'

  # Credit cards
  inflect.human 'americanexpress', 'American Express'
  inflect.human 'amex', 'American Express'
  inflect.human 'visa', 'VISA'
  inflect.acronym 'JCB'
  inflect.human 'jcb', 'JCB'
  inflect.acronym 'UnionPay'
  inflect.human 'unionpay', 'UnionPay'
  inflect.acronym 'MasterCard'
  inflect.human 'mastercard', 'MasterCard'

  # Models
  inflect.irregular 'media', 'medias'
end
