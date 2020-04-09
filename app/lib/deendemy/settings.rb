module DeenDemy
  class Settings
    Phone = Struct.new(:number, :country_code)

    # @return [String]
    def self.name
      'Deendemy'
    end

    # @return [String]
    def self.company_name
      'CodeVillage Ltd'
    end

    # @return [Array]
    def self.phone_numbers
      @phone_numbers ||= [
        Phone.new(ENV.fetch('TWILIO_PHONE_NG', '+2348162740850'), 'NG'),
        Phone.new(ENV['TWILIO_PHONE_CA'], 'CA'),
      ].reject { |n| n.number.nil? }
    end

    # @return [String]
    def self.email
      'hi@deendemy.com'
    end

    # @return [String]
    def self.phone_number_voice
      '+2348162740850'
    end

    # @return [Array]
    def self.ops_email
      ['ops@deendemy.com']
    end

    # @return [Array]
    def self.marketing_email
      ['marketting@deendemy.com']
    end

    # @return [Array]
    def self.accounting_email
      ['accounting@deendemy.com']
    end

    # @return [String]
    def self.devtest_email
      ENV.fetch('DEVTEST_EMAIL', "devtest+#{Rails.env}@deendemy.com")
    end

    # @return [Array]
    def self.tech_leads_email
      ['jatto@deendemy.com']
    end

    # @return [Array]
    def self.execteam_email
      ['execteam@deendemy.com']
    end

    # @return [Array]
    def self.cx_team_email
      ['cx.team@deendemy.com']
    end

    # @return [Array]
    def self.cx_leads_email
      ['ajala@deendemy.com', 'jatto@deendemy.com', 'kishky@deendemy.com']
    end

    # Selects the most appropriate phone number given a country code
    # @param cc [String] Country code
    def self.localized_phone_number(code)
      phone = phone_numbers.detect { |phone| phone.country_code == code }
      phone ? phone.number : phone_numbers.detect { |phone| phone.country_code == 'NG' }.number
    end

    # @return [Array]
    def self.available_countries
      []
    end

    # @return [Array]
    def self.available_languages
      []
    end

    # @return [Array]
    def self.available_permissions
      []
    end

    # @return [Integer] Hour at which the day starts for customers (do not text before)
    def self.customer_day_start
      8
    end

    # @return [Integer] Hour at which the day ends for customers (do not text after)
    def self.customer_day_end
      22
    end

    # @return [String] Name of person signing customs forms
    def self.customs_signer
      'Aminujatto Abdulqahhar'
    end

    # @return [Array]
    def self.allowed_countries
      %w(NG CA)
    end
  end
end
