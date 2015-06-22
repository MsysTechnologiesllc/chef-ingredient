#
# Author:: Joshua Timberman <joshua@getchef.com
# Copyright (c) 2015, Chef Software, Inc. <legal@getchef.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative './helpers'

class Chef
  class Provider
    class OmnibusService < Chef::Provider::LWRPBase
      # Methods for use in resources, found in helpers.rb
      include ChefIngredientCookbook::Helpers

      use_inline_resources

      def whyrun_supported?
        true
      end

      %i[start stop restart hup int kill graceful-kill once].each do |sv_command|
        action sv_command do
          execute "#{get_ctl_command} #{sv_command} #{get_service_properties.last}"
        end
      end

      private
      def get_ctl_command
        new_resource.ctl_command || chef_ctl_command(get_service_properties.first)
      end

      def get_service_properties
        new_resource.service_name.split('/')
      end
    end
  end
end