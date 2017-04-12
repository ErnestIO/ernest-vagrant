# frozen_string_literal: true
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'spec_helper'

describe 'salt' do
  describe 'salt gem installed' do
    describe command 'ls -l /opt/flow-libraries/' do
      its(:stdout) { should include 'salt' }
    end
  end
end
