from slack.signature import SignatureVerifier
import os
import base64
import json
import requests

def receive_gke_req(event, context):
    slack_request = json.loads(base64.b64decode(event['data']))
    response_url = slack_request["data"]["response_url"]

    ProjectID = os.environ['PROJECT_ID']
    zone = os.environ['ZONE']
    
    print(f'event: {event}')
    print(f'context: {context}')
    print(f'slack_request: {slack_request}')
    print(f'response_url: {response_url}')

    # Create Size Request and Set It
    
    text = f'Hello World! Heres what your sent to Slack {slack_request}! ProjectID = {ProjectID}, Zone = {zone}'

    # Send a message back to Slack upon completion   
    message = {        
        "text": text
    }
    res = requests.post(response_url, json=message)
    return