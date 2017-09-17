# frozen_string_literal: true

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'test_utils')

include TZInfo

module DataSources
  class TCTimezoneInfo < Minitest::Test

    def test_identifier
      ti = TimezoneInfo.new('Test/Zone')
      assert_equal('Test/Zone', ti.identifier)
      assert(ti.identifier.frozen?)
    end

    def test_inspect
      ti = TimezoneInfo.new('Test/Zone')
      assert_equal('#<TZInfo::DataSources::TimezoneInfo: Test/Zone>', ti.inspect)
    end

    def test_create_timezone
      ti = TimezoneInfo.new('Test/Zone')
      error = assert_raises(NotImplementedError) { ti.create_timezone }
      assert_equal('Subclasses must override create_timezone', error.message)
    end
  end
end
