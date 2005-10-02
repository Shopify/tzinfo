$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'tzinfo/timezone'

include TZInfo

class TCTimezoneLondon < Test::Unit::TestCase
  def test_2004
    #Europe/London  Sun Mar 28 00:59:59 2004 UTC = Sun Mar 28 00:59:59 2004 GMT isdst=0 gmtoff=0
    #Europe/London  Sun Mar 28 01:00:00 2004 UTC = Sun Mar 28 02:00:00 2004 BST isdst=1 gmtoff=3600
    #Europe/London  Sun Oct 31 00:59:59 2004 UTC = Sun Oct 31 01:59:59 2004 BST isdst=1 gmtoff=3600
    #Europe/London  Sun Oct 31 01:00:00 2004 UTC = Sun Oct 31 01:00:00 2004 GMT isdst=0 gmtoff=0
    
    tz = Timezone.get('Europe/London')
    assert_equal(DateTime.new(2004,3,28,0,59,59), tz.utc_to_local(DateTime.new(2004,3,28,0,59,59)))
    assert_equal(DateTime.new(2004,3,28,2,0,0), tz.utc_to_local(DateTime.new(2004,3,28,1,0,0)))    
    assert_equal(DateTime.new(2004,10,31,1,59,59), tz.utc_to_local(DateTime.new(2004,10,31,0,59,59)))
    assert_equal(DateTime.new(2004,10,31,1,0,0), tz.utc_to_local(DateTime.new(2004,10,31,1,0,0)))
    
    assert_equal(DateTime.new(2004,3,28,0,59,59), tz.local_to_utc(DateTime.new(2004,3,28,0,59,59)))
    assert_equal(DateTime.new(2004,3,28,1,0,0), tz.local_to_utc(DateTime.new(2004,3,28,2,0,0)))
    assert_equal(DateTime.new(2004,10,31,0,59,59), tz.local_to_utc(DateTime.new(2004,10,31,1,59,59)))
    assert_equal(DateTime.new(2004,10,31,0,0,0), tz.local_to_utc(DateTime.new(2004,10,31,1,0,0))) # returns first possible utc time
    
    assert_raise(PeriodNotFound) { tz.local_to_utc(DateTime.new(2004,3,28,1,0,0)) }
    
    assert_equal(:GMT, tz.period_for_utc(DateTime.new(2004,3,28,0,59,59)).zone_identifier)
    assert_equal(:BST, tz.period_for_utc(DateTime.new(2004,3,28,1,0,0)).zone_identifier)
    assert_equal(:BST, tz.period_for_utc(DateTime.new(2004,10,31,0,59,59)).zone_identifier)
    assert_equal(:GMT, tz.period_for_utc(DateTime.new(2004,10,31,1,0,0)).zone_identifier)
    
    assert_equal(:GMT, tz.period_for_local(DateTime.new(2004,3,28,0,59,59)).zone_identifier)
    assert_equal(:BST, tz.period_for_local(DateTime.new(2004,3,28,2,0,0)).zone_identifier)
    assert_equal(:BST, tz.period_for_local(DateTime.new(2004,10,31,1,59,59)).zone_identifier)
    assert_equal(:BST, tz.period_for_local(DateTime.new(2004,10,31,1,0,0)).zone_identifier)
    
    assert_equal(0, tz.period_for_utc(DateTime.new(2004,3,28,0,59,59)).utc_total_offset)
    assert_equal(3600, tz.period_for_utc(DateTime.new(2004,3,28,1,0,0)).utc_total_offset)
    assert_equal(3600, tz.period_for_utc(DateTime.new(2004,10,31,0,59,59)).utc_total_offset)
    assert_equal(0, tz.period_for_utc(DateTime.new(2004,10,31,1,0,0)).utc_total_offset)
    
    assert_equal(0, tz.period_for_local(DateTime.new(2004,3,28,0,59,59)).utc_total_offset)
    assert_equal(3600, tz.period_for_local(DateTime.new(2004,3,28,2,0,0)).utc_total_offset)
    assert_equal(3600, tz.period_for_local(DateTime.new(2004,10,31,1,59,59)).utc_total_offset)
    assert_equal(3600, tz.period_for_local(DateTime.new(2004,10,31,1,0,0)).utc_total_offset)
  end    
end