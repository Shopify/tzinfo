# frozen_string_literal: true

module TZInfo
  # The {Localized} module is included in {LocalTime}, {LocalDateTime} and
  # {LocalTimestamp}. It provides an override for the {strftime} method that
  # handles expanding the `%Z` directive according to the
  # {TimezoneOffset#abbreviation abbreviation} of the {TimezoneOffset}
  # associated with a local time.
  module Localized
    # Overrides the `Time`, `DateTime` or {Timestamp} version of `strftime`,
    # replacing `%Z` with the {TimezoneOffset#abbreviation abbreviation} of the
    # associated {TimezoneOffset}. If there is no associated offset, `%Z` is
    # expanded by the base class instead.
    #
    # All the format directives handled by the base class are supported.
    #
    # @param format [String] the format string.
    # @return [String] the formatted time.
    # @raise [ArgumentError] if `format` is `nil`.
    def strftime(format)
      raise ArgumentError, 'format must be specified' unless format

      if_offset_info do |o|
        abbreviation = o.abbreviation.gsub(/%/, '%%')

        format = format.gsub(/%(%*)Z/) do
          if $1.length.odd?
            # Return %%Z so the real strftime treats it as a literal %Z too.
            "#$1%Z"
          else
            "#$1#{abbreviation}"
          end
        end
      end

      super
    end

    protected

    # Performs a calculation if there is an associated {TimezoneOffset}.
    #
    # @param result [Object] a result value that can be manipulated by the block
    #   if there is an associated {TimezoneOffset}.
    # @yield [period, result] if there is an associated {TimezoneOffset}, the
    #   block is yielded to in order to calculate the method result.
    # @yieldparam period [TimezoneOffset] the associated {TimezoneOffset}.
    # @yieldparam result [Object] the `result` parameter.
    # @yieldreturn [Object] the result of the calculation performed if there is
    #   an associated {TimezoneOffset}.
    # @return [Object] the result of the block if there is an associated
    #   {TimezoneOffset}, otherwise the `result` parameter.
    #
    # @private
    def if_offset_info(result = nil) #:nodoc:
      o = offset_info
      o ? yield(o, result) : result
    end
  end
end