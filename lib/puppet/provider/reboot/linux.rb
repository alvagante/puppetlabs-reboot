require 'pathname'
require Pathname.new(__FILE__).dirname + '../../../' + 'puppet/provider/reboot/posix'
#require Pathname.new(__FILE__).dirname + '../../../' + 'puppet_x/reboot/check_retries' 

Puppet::Type.type(:reboot).provide :linux, :parent => :posix do
  confine :kernel => :linux
#  include PuppetX::Reboot::CheckRetries

  def initialize(resource = nil)
    Puppet.deprecation_warning "The 'linux' reboot provider is deprecated and will be removed; use 'posix' instead."
    super(resource)
  end
end
