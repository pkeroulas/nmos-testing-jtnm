# Copyright (C) 2020 Advanced Media Workflow Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from . import Config as CONFIG

print('****************************************************************')
print('***************  JT-NM config loaded     ***********************')
print('****************************************************************')

CONFIG.ENABLE_HTTPS = False
CONFIG.ENABLE_DNS_SD = True
CONFIG.DNS_SD_MODE = 'unicast'
CONFIG.DNS_DOMAIN = 'nmos-testing.jt-nm.org'
CONFIG.DNS_UPSTREAM_IP = '192.168.6.1'
#CONFIG.DNS_SD_ADVERT_TIMEOUT = 30 # sufficient to cover the DuT’s boot time
print(CONFIG)
