import json
import pprint
pp = pprint.PrettyPrinter(indent=4)

with open("/tmp/sample-scanner.json") as file:
    # Load its content and make a new dictionary
    data = json.load(file)

# [
#   {
#     "path": "runnable/index.js",
#     "start_line": 1,
#     "end_line": 1,
#     "start_column": 1,
#     "end_column": 1,
#     "title": "Ignore this annotation",
#     "message": "It's just used as an example",
#     "annotation_level": "notice"
#   }
# ]
annotations=[]

for hit in data['hits']:
    annotation={}
    annotation['path'] = hit['filename']
    annotation['start_line'] = hit['line']
    annotation['end_line'] = hit['line']
    annotation['start_column'] = '1'
    annotation['end_column'] = '1'
    annotation['title'] = hit['severity']
    annotation['message'] = f"""category={hit['category']}
    code={hit['code']}
    cwe={hit['cwe']}
    solution={hit['solution']}
    """
    annotations.append(annotation)

pprint.pprint(annotations)


with open(".sample-scanner.json", "w") as outfile:
    json.dump(annotations, outfile, indent=4)