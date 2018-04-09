module PuppetX
  module Reboot
    module CheckRetries
      def check_retries
        retries_log = Puppet['statedir'] + '\reboot_retries.log'
        if @resource[:retries] == 0
          exit
        else
          FileUtils.touch(retries_log)
          total_reboots = File.open(retries_log) { |f| f.count }
          retries_date = IO.readlines(retries_log)[(total_reboots - @resource[:retries]).to_i - 1]
          interval_date = Time.now - ( @resource[:retries_interval] * 60 * 60 )
          retries_timestamp = retries_date.nil? ? '0' : Time.parse(retries_date.to_s).to_i
          interval_timestamp = interval_date.to_i
          Puppet.info("total_reboots = #{total_reboots} - retries_date = #{retries_date} - interval_date = #{interval_date} - retries_timestamp = #{retries_timestamp} - interval_timestamp = #{interval_timestamp}")
          if retries_date.nil? or retries_timestamp < interval_timestamp
            open(retries_log, 'a') do |f|
              f.puts Time.now
            end
            Puppet.notice("Retries count not exceeded. Triggering reboot.")
          else
            Puppet.warning("Reboot skipped because the maximum number of retries in the given retries_period has been exceeded.")
            abort
          end
        end
      end
    end
  end
end
