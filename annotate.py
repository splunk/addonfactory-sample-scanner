import json
import pprint
import os
from collections.abc import Iterable

pp = pprint.PrettyPrinter(indent=4)
ws = os.environ['GITHUB_WORKSPACE']
#   ########################################################################
#   Copyright 2021 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 

with open("/dev/stdin") as file:
    # Load its content and make a new dictionary
    data = json.load(file)


rd = {}
rd['source']={'name':'addonfactor-sample-scanner','url':'https://github.com/splunk/addonfactory-sample-scanner'}
rd['severity']='ERROR'

diagnostics=[]

HITS = 'hits'
if data and (HITS in data) and data[HITS] and isinstance(data[HITS], Iterable):
    for hit in data[HITS]:
        diagnostic={}
        diagnostic['location'] ={
            'path': hit['filename'].replace(f'{ws}/',''),
            'range': {
                'start': {
                    'line': hit['line'],
                    'column': 1
                }
            }
        }
        diagnostic['severity'] ="ERROR"
        diagnostic['code'] = {
            "value": "hit['code']"
        }

        diagnostic['message'] = f"""{hit['caption']}
        solution={hit['solution']}
        category={hit['category']}
        code={hit['code']}
        confidence={hit['confidence']}
        cwe={hit['cwe']}
        labels={hit['labels']}
        """
        diagnostics.append(diagnostic)

    rd['diagnostics']=diagnostics

    json_formatted_str = json.dumps(rd, indent=4)
    print(json_formatted_str)
