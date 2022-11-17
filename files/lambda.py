import json

def echo(event, context):
    print(f'{json.dumps(event)}')
    body = f"{event.get('headers').get('host', 'NO HOST - healthcheck probe ?')}{event['path']}\n"
    response = {
        "statusCode": 200,
        "isBase64Encoded": False,
        "headers": {"Content-Type": "text/plain;"},
        'body': body
    }
    return response
