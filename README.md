puppet-flowdock
==========

Description
-----------

A Puppet report handler for sending notifications of failed runs to Flowdock.

Requirements
------------

* `flowdock`
* `puppet` (version 2.6.5 and later)

Installation & Usage
--------------------

1.  Install the `flowdock` gem on your Puppet master

        $ sudo gem install flowdock

2.  Install puppet-flowdock as a module in your Puppet master's module
    path.

3.  Create `/etc/puppet/flowdock.yaml` file in the Puppet master with at least your Flowdock API key,
    and possibly other config options.

        ---
        {
          :flowdock_api_key: "your_key", # mandatory
          :statuses: ["failed", "changed", "unchanged"], # default to ["failed"]
          :level: :warning, # Puppet output level (warning, notice, info,...)
          :from_address: 'from@acme.com'
        }

4.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = flowdock
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

5.  Run the Puppet client and sync the report as a plugin


Authors
-------

James Turnbull <james@lovedthanlost.net>

Carlos Sanchez <csanchez@maestrodev.com>

License
-------

    Author:: James Turnbull <james@lovedthanlost.net>, Carlos Sanchez <csanchez@maestrodev.com>
    Copyright:: Copyright (c) 2012 James Turnbull, MaestroDev Inc.
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
