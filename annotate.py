import json
import pprint
import os
pp = pprint.PrettyPrinter(indent=4)
ws = os.environ['GITHUB_WORKSPACE']

with open("/dev/stdin") as file:
    # Load its content and make a new dictionary
    data = json.load(file)



rd = {}
rd['source']={'name':'addonfactor-sample-scanner','url':'https://github.com/splunk/addonfactory-sample-scanner'}
rd['severity']='ERROR'

diagnostics=[]

for hit in data['hits']:
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

# with open("/dev/stdout", "w") as outfile:
#     json.dump(rd, outfile, indent=4)
json_formatted_str = json.dumps(rd, indent=4)
print(json_formatted_str)