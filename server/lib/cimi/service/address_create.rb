# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

class CIMI::Service::AddressCreate < CIMI::Service::Base

  def create
    template = resolve(address_template)

    params = {
      :name => name,
      :description => description,
      :address_template => template,
      :env => context # FIXME: We should not pass the context to the driver (!)
    }

    unless context.driver.respond_to? :create_address
       raise Deltacloud::Exceptions.exception_from_status(
         501,
         "Creating Address is not supported by the current driver"
       )
    end

    address = context.driver.create_address(context.credentials, params)

    result = CIMI::Service::Address.from_address(address, context)
    result.name = name if name
    result.description = description if description
    result.property = property if property
    result.save
    result
  end

end
