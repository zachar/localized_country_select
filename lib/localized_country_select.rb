# = LocalizedCountrySelect
#
# View helper for displaying select list with countries:
#
#     localized_country_select(:user, :country)
#
# Works just like the default Rails' +country_select+ plugin, but stores countries as
# country *codes*, not *names*, in the database.
#
# You can easily translate country codes in your application like this:
#     <%= I18n.t @user.country, :scope => 'countries' %>
#
# Uses the Rails internationalization framework (I18n) for translating the names of countries.
#
# Use Rake task <tt>rake import:country_select 'de'</tt> for importing country names
# from Unicode.org's CLDR repository (http://www.unicode.org/cldr/data/charts/summary/root.html)
#
# Code adapted from Rails' default +country_select+ plugin (previously in core)
# See http://github.com/rails/country_select/tree/master/lib/country_select.rb
#

module LocalizedCountrySelect
  class << self
    COUNTRIES_FALLBACK = {
     pl: {:AC=>"Wyspa Wniebowstąpienia", :AD=>"Andora", :AE=>"Zjednoczone Emiraty Arabskie", :AF=>"Afganistan", :AG=>"Antigua i Barbuda", :AI=>"Anguilla", :AL=>"Albania", :AM=>"Armenia", :AN=>"Antyle Holenderskie", :AO=>"Angola", :AQ=>"Antarktyka", :AR=>"Argentyna", :AS=>"Samoa Amerykańskie", :AT=>"Austria", :AU=>"Australia", :AW=>"Aruba", :AX=>"Wyspy Alandzkie", :AZ=>"Azerbejdżan", :BA=>"Bośnia i Hercegowina", :BB=>"Barbados", :BD=>"Bangladesz", :BE=>"Belgia", :BF=>"Burkina Faso", :BG=>"Bułgaria", :BH=>"Bahrajn", :BI=>"Burundi", :BJ=>"Benin", :BL=>"Saint-Barthélemy", :BM=>"Bermudy", :BN=>"Brunei Darussalam", :BO=>"Boliwia", :BQ=>"Niderlandy Karaibskie", :BR=>"Brazylia", :BS=>"Bahamy", :BT=>"Bhutan", :BV=>"Wyspa Bouveta", :BW=>"Botswana", :BY=>"Białoruś", :BZ=>"Belize", :CA=>"Kanada", :CC=>"Wyspy Kokosowe", :CD=>"Demokratyczna Republika Konga", :CF=>"Republika Środkowoafrykańska", :CG=>"Kongo", :CH=>"Szwajcaria", :CI=>"Côte d’Ivoire", :CK=>"Wyspy Cooka", :CL=>"Chile", :CM=>"Kamerun", :CN=>"Chiny", :CO=>"Kolumbia", :CP=>"Clipperton", :CR=>"Kostaryka", :CU=>"Kuba", :CV=>"Republika Zielonego Przylądka", :CW=>"Curaçao", :CX=>"Wyspa Bożego Narodzenia", :CY=>"Cypr", :CZ=>"Czechy", :DE=>"Niemcy", :DG=>"Diego Garcia", :DJ=>"Dżibuti", :DK=>"Dania", :DM=>"Dominika", :DO=>"Dominikana", :DZ=>"Algieria", :EA=>"Ceuta i Melilla", :EC=>"Ekwador", :EE=>"Estonia", :EG=>"Egipt", :EH=>"Sahara Zachodnia", :ER=>"Erytrea", :ES=>"Hiszpania", :ET=>"Etiopia", :EU=>"Unia Europejska", :FI=>"Finlandia", :FJ=>"Fidżi", :FK=>"Falklandy", :FM=>"Mikronezja", :FO=>"Wyspy Owcze", :FR=>"Francja", :GA=>"Gabon", :GB=>"Wielka Brytania", :GD=>"Grenada", :GE=>"Gruzja", :GF=>"Gujana Francuska", :GG=>"Wyspa Guernsey", :GH=>"Ghana", :GI=>"Gibraltar", :GL=>"Grenlandia", :GM=>"Gambia", :GN=>"Gwinea", :GP=>"Gwadelupa", :GQ=>"Gwinea Równikowa", :GR=>"Grecja", :GS=>"Georgia Południowa i Sandwich Południowy", :GT=>"Gwatemala", :GU=>"Guam", :GW=>"Gwinea Bissau", :GY=>"Gujana", :HK=>"Hongkong SAR", :HM=>"Wyspy Heard i McDonalda", :HN=>"Honduras", :HR=>"Chorwacja", :HT=>"Haiti", :HU=>"Węgry", :IC=>"Wyspy Kanaryjskie", :ID=>"Indonezja", :IE=>"Irlandia", :IL=>"Izrael", :IM=>"Wyspa Man", :IN=>"Indie", :IO=>"Brytyjskie Terytorium Oceanu Indyjskiego", :IQ=>"Irak", :IR=>"Iran", :IS=>"Islandia", :IT=>"Włochy", :JE=>"Wyspa Jersey", :JM=>"Jamajka", :JO=>"Jordania", :JP=>"Japonia", :KE=>"Kenia", :KG=>"Kirgistan", :KH=>"Kambodża", :KI=>"Kiribati", :KM=>"Komory", :KN=>"Saint Kitts i Nevis", :KP=>"Korea Północna", :KR=>"Korea Południowa", :KW=>"Kuwejt", :KY=>"Kajmany", :KZ=>"Kazachstan", :LA=>"Laos", :LB=>"Liban", :LC=>"Saint Lucia", :LI=>"Liechtenstein", :LK=>"Sri Lanka", :LR=>"Liberia", :LS=>"Lesotho", :LT=>"Litwa", :LU=>"Luksemburg", :LV=>"Łotwa", :LY=>"Libia", :MA=>"Maroko", :MC=>"Monako", :MD=>"Mołdawia", :ME=>"Czarnogóra", :MF=>"Saint-Martin", :MG=>"Madagaskar", :MH=>"Wyspy Marshalla", :MK=>"Macedonia", :ML=>"Mali", :MM=>"Mjanma (Birma)", :MN=>"Mongolia", :MO=>"Makau SAR", :MP=>"Mariany Północne", :MQ=>"Martynika", :MR=>"Mauretania", :MS=>"Montserrat", :MT=>"Malta", :MU=>"Mauritius", :MV=>"Malediwy", :MW=>"Malawi", :MX=>"Meksyk", :MY=>"Malezja", :MZ=>"Mozambik", :NA=>"Namibia", :NC=>"Nowa Kaledonia", :NE=>"Niger", :NF=>"Norfolk", :NG=>"Nigeria", :NI=>"Nikaragua", :NL=>"Holandia", :NO=>"Norwegia", :NP=>"Nepal", :NR=>"Nauru", :NU=>"Niue", :NZ=>"Nowa Zelandia", :OM=>"Oman", :PA=>"Panama", :PE=>"Peru", :PF=>"Polinezja Francuska", :PG=>"Papua-Nowa Gwinea", :PH=>"Filipiny", :PK=>"Pakistan", :PL=>"Polska", :PM=>"Saint-Pierre i Miquelon", :PN=>"Pitcairn", :PR=>"Portoryko", :PS=>"Terytoria Palestyńskie", :PT=>"Portugalia", :PW=>"Palau", :PY=>"Paragwaj", :QA=>"Katar", :QO=>"Oceania inne", :RE=>"Reunion", :RO=>"Rumunia", :RS=>"Serbia", :RU=>"Rosja", :RW=>"Rwanda", :SA=>"Arabia Saudyjska", :SB=>"Wyspy Salomona", :SC=>"Seszele", :SD=>"Sudan", :SE=>"Szwecja", :SG=>"Singapur", :SH=>"Wyspa Świętej Heleny", :SI=>"Słowenia", :SJ=>"Svalbard i Jan Mayen", :SK=>"Słowacja", :SL=>"Sierra Leone", :SM=>"San Marino", :SN=>"Senegal", :SO=>"Somalia", :SR=>"Surinam", :SS=>"Sudan Południowy", :ST=>"Wyspy Świętego Tomasza i Książęca", :SV=>"Salwador", :SX=>"Sint Maarten", :SY=>"Syria", :SZ=>"Suazi", :TA=>"Tristan da Cunha", :TC=>"Turks i Caicos", :TD=>"Czad", :TF=>"Francuskie Terytoria Południowe", :TG=>"Togo", :TH=>"Tajlandia", :TJ=>"Tadżykistan", :TK=>"Tokelau", :TL=>"Timor Wschodni", :TM=>"Turkmenistan", :TN=>"Tunezja", :TO=>"Tonga", :TR=>"Turcja", :TT=>"Trynidad i Tobago", :TV=>"Tuvalu", :TW=>"Tajwan", :TZ=>"Tanzania", :UA=>"Ukraina", :UG=>"Uganda", :UM=>"Dalekie Wyspy Mniejsze Stanów Zjednoczonych", :US=>"Stany Zjednoczone", :UY=>"Urugwaj", :UZ=>"Uzbekistan", :VA=>"Watykan", :VC=>"Saint Vincent i Grenadyny", :VE=>"Wenezuela", :VG=>"Brytyjskie Wyspy Dziewicze", :VI=>"Wyspy Dziewicze Stanów Zjednoczonych", :VN=>"Wietnam", :VU=>"Vanuatu", :WF=>"Wallis i Futuna", :WS=>"Samoa", :XK=>"Kosowo", :YE=>"Jemen", :YT=>"Majotta", :ZA=>"Republika Południowej Afryki", :ZM=>"Zambia", :ZW=>"Zimbabwe", :ZZ=>"Nieznany region"},
     en: {:AC=>"Ascension Island", :AD=>"Andorra", :AE=>"United Arab Emirates", :AF=>"Afghanistan", :AG=>"Antigua and Barbuda", :AI=>"Anguilla", :AL=>"Albania", :AM=>"Armenia", :AN=>"Netherlands Antilles", :AO=>"Angola", :AQ=>"Antarctica", :AR=>"Argentina", :AS=>"American Samoa", :AT=>"Austria", :AU=>"Australia", :AW=>"Aruba", :AX=>"Åland Islands", :AZ=>"Azerbaijan", :BA=>"Bosnia and Herzegovina", :BB=>"Barbados", :BD=>"Bangladesh", :BE=>"Belgium", :BF=>"Burkina Faso", :BG=>"Bulgaria", :BH=>"Bahrain", :BI=>"Burundi", :BJ=>"Benin", :BL=>"Saint Barthélemy", :BM=>"Bermuda", :BN=>"Brunei", :BO=>"Bolivia", :BQ=>"Caribbean Netherlands", :BR=>"Brazil", :BS=>"Bahamas", :BT=>"Bhutan", :BV=>"Bouvet Island", :BW=>"Botswana", :BY=>"Belarus", :BZ=>"Belize", :CA=>"Canada", :CC=>"Cocos (Keeling) Islands", :CD=>"Congo - Kinshasa", :CF=>"Central African Republic", :CG=>"Congo - Brazzaville", :CH=>"Switzerland", :CI=>"Côte d’Ivoire", :CK=>"Cook Islands", :CL=>"Chile", :CM=>"Cameroon", :CN=>"China", :CO=>"Colombia", :CP=>"Clipperton Island", :CR=>"Costa Rica", :CU=>"Cuba", :CV=>"Cape Verde", :CW=>"Curaçao", :CX=>"Christmas Island", :CY=>"Cyprus", :CZ=>"Czech Republic", :DE=>"Germany", :DG=>"Diego Garcia", :DJ=>"Djibouti", :DK=>"Denmark", :DM=>"Dominica", :DO=>"Dominican Republic", :DZ=>"Algeria", :EA=>"Ceuta and Melilla", :EC=>"Ecuador", :EE=>"Estonia", :EG=>"Egypt", :EH=>"Western Sahara", :ER=>"Eritrea", :ES=>"Spain", :ET=>"Ethiopia", :EU=>"European Union", :FI=>"Finland", :FJ=>"Fiji", :FK=>"Falkland Islands", :FM=>"Micronesia", :FO=>"Faroe Islands", :FR=>"France", :GA=>"Gabon", :GB=>"United Kingdom", :GD=>"Grenada", :GE=>"Georgia", :GF=>"French Guiana", :GG=>"Guernsey", :GH=>"Ghana", :GI=>"Gibraltar", :GL=>"Greenland", :GM=>"Gambia", :GN=>"Guinea", :GP=>"Guadeloupe", :GQ=>"Equatorial Guinea", :GR=>"Greece", :GS=>"South Georgia & South Sandwich Islands", :GT=>"Guatemala", :GU=>"Guam", :GW=>"Guinea-Bissau", :GY=>"Guyana", :HK=>"Hong Kong SAR China", :HM=>"Heard & McDonald Islands", :HN=>"Honduras", :HR=>"Croatia", :HT=>"Haiti", :HU=>"Hungary", :IC=>"Canary Islands", :ID=>"Indonesia", :IE=>"Ireland", :IL=>"Israel", :IM=>"Isle of Man", :IN=>"India", :IO=>"British Indian Ocean Territory", :IQ=>"Iraq", :IR=>"Iran", :IS=>"Iceland", :IT=>"Italy", :JE=>"Jersey", :JM=>"Jamaica", :JO=>"Jordan", :JP=>"Japan", :KE=>"Kenya", :KG=>"Kyrgyzstan", :KH=>"Cambodia", :KI=>"Kiribati", :KM=>"Comoros", :KN=>"Saint Kitts and Nevis", :KP=>"North Korea", :KR=>"South Korea", :KW=>"Kuwait", :KY=>"Cayman Islands", :KZ=>"Kazakhstan", :LA=>"Laos", :LB=>"Lebanon", :LC=>"Saint Lucia", :LI=>"Liechtenstein", :LK=>"Sri Lanka", :LR=>"Liberia", :LS=>"Lesotho", :LT=>"Lithuania", :LU=>"Luxembourg", :LV=>"Latvia", :LY=>"Libya", :MA=>"Morocco", :MC=>"Monaco", :MD=>"Moldova", :ME=>"Montenegro", :MF=>"Saint Martin", :MG=>"Madagascar", :MH=>"Marshall Islands", :MK=>"Macedonia", :ML=>"Mali", :MM=>"Myanmar (Burma)", :MN=>"Mongolia", :MO=>"Macau SAR China", :MP=>"Northern Mariana Islands", :MQ=>"Martinique", :MR=>"Mauritania", :MS=>"Montserrat", :MT=>"Malta", :MU=>"Mauritius", :MV=>"Maldives", :MW=>"Malawi", :MX=>"Mexico", :MY=>"Malaysia", :MZ=>"Mozambique", :NA=>"Namibia", :NC=>"New Caledonia", :NE=>"Niger", :NF=>"Norfolk Island", :NG=>"Nigeria", :NI=>"Nicaragua", :NL=>"Netherlands", :NO=>"Norway", :NP=>"Nepal", :NR=>"Nauru", :NU=>"Niue", :NZ=>"New Zealand", :OM=>"Oman", :PA=>"Panama", :PE=>"Peru", :PF=>"French Polynesia", :PG=>"Papua New Guinea", :PH=>"Philippines", :PK=>"Pakistan", :PL=>"Poland", :PM=>"Saint Pierre and Miquelon", :PN=>"Pitcairn Islands", :PR=>"Puerto Rico", :PS=>"Palestinian Territories", :PT=>"Portugal", :PW=>"Palau", :PY=>"Paraguay", :QA=>"Qatar", :QO=>"Outlying Oceania", :RE=>"Réunion", :RO=>"Romania", :RS=>"Serbia", :RU=>"Russia", :RW=>"Rwanda", :SA=>"Saudi Arabia", :SB=>"Solomon Islands", :SC=>"Seychelles", :SD=>"Sudan", :SE=>"Sweden", :SG=>"Singapore", :SH=>"Saint Helena", :SI=>"Slovenia", :SJ=>"Svalbard and Jan Mayen", :SK=>"Slovakia", :SL=>"Sierra Leone", :SM=>"San Marino", :SN=>"Senegal", :SO=>"Somalia", :SR=>"Suriname", :SS=>"South Sudan", :ST=>"São Tomé and Príncipe", :SV=>"El Salvador", :SX=>"Sint Maarten", :SY=>"Syria", :SZ=>"Swaziland", :TA=>"Tristan da Cunha", :TC=>"Turks and Caicos Islands", :TD=>"Chad", :TF=>"French Southern Territories", :TG=>"Togo", :TH=>"Thailand", :TJ=>"Tajikistan", :TK=>"Tokelau", :TL=>"Timor-Leste", :TM=>"Turkmenistan", :TN=>"Tunisia", :TO=>"Tonga", :TR=>"Turkey", :TT=>"Trinidad and Tobago", :TV=>"Tuvalu", :TW=>"Taiwan", :TZ=>"Tanzania", :UA=>"Ukraine", :UG=>"Uganda", :UM=>"U.S. Outlying Islands", :US=>"United States", :UY=>"Uruguay", :UZ=>"Uzbekistan", :VA=>"Vatican City", :VC=>"St. Vincent & Grenadines", :VE=>"Venezuela", :VG=>"British Virgin Islands", :VI=>"U.S. Virgin Islands", :VN=>"Vietnam", :VU=>"Vanuatu", :WF=>"Wallis and Futuna", :WS=>"Samoa", :XK=>"Kosovo", :YE=>"Yemen", :YT=>"Mayotte", :ZA=>"South Africa", :ZM=>"Zambia", :ZW=>"Zimbabwe", :ZZ=>"Unknown Region"}
    }

    # Returns array with codes and localized country names (according to <tt>I18n.locale</tt>)
    # for <tt><option></tt> tags
    def localized_countries_array(options={})
      exclude = Array(options[:exclude]).map {|code| code.to_s.upcase }
      if(options[:description]==:abbreviated)
        if Rails.env!='staging'
          I18n.translate(:countries).map { |key, value| [key.to_s.upcase] if !exclude.include?(key.to_s.upcase) }
        else
          COUNTRIES_FALLBACK[I18n.locale].map { |key, value| [key.to_s.upcase] if !exclude.include?(key.to_s.upcase) }
        end
      else
        if Rails.env!='staging'
          I18n.translate(:countries).map { |key, value| [value, key.to_s.upcase] if !exclude.include?(key.to_s.upcase) }
        else
          COUNTRIES_FALLBACK[I18n.locale].map { |key, value| [value, key.to_s.upcase] if !exclude.include?(key.to_s.upcase) }
        end
      end.compact.sort_by { |country| country.first.parameterize }
    end
    # Return array with codes and localized country names for array of country codes passed as argument
    # == Example
    #   priority_countries_array([:TW, :CN])
    #   # => [ ['Taiwan', 'TW'], ['China', 'CN'] ]
    def priority_countries_array(country_codes=[],options={})
      if(options[:description]==:abbreviated)
        country_codes.map { |code| [code.to_s.upcase] }
      else
        countries = I18n.translate(:countries)
        country_codes.map { |code| [countries[code.to_s.upcase.to_sym], code.to_s.upcase] }
      end
    end
  end
end

module ActionView
  module Helpers

    module FormOptionsHelper

      # Return select and option tags for the given object and method, using +localized_country_options_for_select+
      # to generate the list of option tags. Uses <b>country code</b>, not name as option +value+.
      # Country codes listed as an array of symbols in +priority_countries+ argument will be listed first
      # TODO : Implement pseudo-named args with a hash, not the "somebody said PHP?" multiple args sillines
      def localized_country_select(object, method, priority_countries = nil, options = {}, html_options = {})
        tag = if defined?(ActionView::Helpers::InstanceTag) &&
                ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0

                InstanceTag.new(object, method, self, options.delete(:object))
              else
                CountrySelect.new(object, method, self, options)
              end

        tag.to_localized_country_select_tag(priority_countries, options, html_options)
      end
      alias_method :country_select, :localized_country_select

      # Return "named" select and option tags according to given arguments.
      # Use +selected_value+ for setting initial value
      # It behaves likes older object-binded brother +localized_country_select+ otherwise
      # TODO : Implement pseudo-named args with a hash, not the "somebody said PHP?" multiple args sillines
      def localized_country_select_tag(name, selected_value = nil, priority_countries = nil, html_options = {})
        select_tag name.to_sym, localized_country_options_for_select(selected_value, priority_countries).html_safe, html_options.stringify_keys
      end
      alias_method :country_select_tag, :localized_country_select_tag

      # Returns a string of option tags for countries according to locale. Supply the country code in upper-case ('US', 'DE')
      # as +selected+ to have it marked as the selected option tag.
      # Country codes listed as an array of symbols in +priority_countries+ argument will be listed first
      def localized_country_options_for_select(selected = nil, priority_countries = nil, options={})
        country_options = "".html_safe
        if priority_countries
          country_options += options_for_select(LocalizedCountrySelect::priority_countries_array(priority_countries, options), selected)
          country_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n".html_safe
          return country_options + options_for_select(LocalizedCountrySelect::localized_countries_array(options) - LocalizedCountrySelect::priority_countries_array(priority_countries, options), selected)
        else
          return country_options + options_for_select(LocalizedCountrySelect::localized_countries_array(options), selected)
        end
      end
      alias_method :country_options_for_select, :localized_country_options_for_select

    end

    module ToCountrySelectTag
      def to_localized_country_select_tag(priority_countries, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        content_tag("select",
          add_options(
            localized_country_options_for_select(value, priority_countries, options).html_safe,
            options, value
          ), html_options
        )
      end
    end

    if defined?(ActionView::Helpers::InstanceTag) &&
        ActionView::Helpers::InstanceTag.instance_method(:initialize).arity != 0
      class InstanceTag
        include ToCountrySelectTag
      end
    else
      class CountrySelect < Tags::Base
        include ToCountrySelectTag
      end
    end

    class FormBuilder
      def localized_country_select(method, priority_countries = nil, options = {}, html_options = {})
        @template.localized_country_select(@object_name, method, priority_countries, options.merge(:object => @object), html_options)
      end
      alias_method :country_select, :localized_country_select
    end

  end
end

if defined?(Rails)
  require "localized_country_select/railtie"
end