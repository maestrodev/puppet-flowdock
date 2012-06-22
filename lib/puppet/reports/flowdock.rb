require 'puppet'
require 'yaml'

begin
  require 'flowdock'
rescue LoadError => e
  Puppet.warn "You need the `flowdock` gem to use the Flowdock report"
end

unless Puppet.version >= '2.6.5'
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:flowdock) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "flowdock.yaml"])
  raise(Puppet::ParseError, "Flowdock report config file #{configfile} not readable") unless File.exist?(configfile)
  @config = YAML.load_file(configfile)

  API_KEY = @config[:flowdock_api_key]
  STATUSES = @config[:statuses] || ['failed']
  LEVEL = @config[:level] || :warning
  ADDRESS = @config[:from_address] || 'puppet@yourdomain.com'

  include Puppet::Util::Colors

  desc <<-DESC
  Send notification of reports to Flowdock.
  DESC

  def process
    if STATUSES.include? self.status
      output = ""
      self.logs.each do |log|
        if Puppet::Util::Log.levels.index(log.level) >= Puppet::Util::Log.levels.index(LEVEL)
          s = html_color(log.level, "#{log.source}: #{log.message}") + "</br>"
          output = output + s
        end
      end

      # create a new Flow object with API Token and sender information
      flow = Flowdock::Flow.new(:api_token => API_KEY,
        :source => "Puppet",
        :from => {:name => self.host, :address => ADDRESS})

      # Accommodate an HTTPS proxy setting
      if proxy = ENV['HTTPS_PROXY']
        proxy = URI.parse(proxy)
        Flowdock::Flow.http_proxy proxy.host, proxy.port
      end

      # send message to the flow
      flow.push_to_team_inbox(:subject => "Puppet run [#{self.status}].",
        :content => output.empty? ? "no output" : output,
        :tags => ["puppet", "#{self.status}", "#{self.host}"])
    end
  end
end
