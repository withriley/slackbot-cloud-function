import os
import time
import hmac
import hashlib
import json
from google.cloud import pubsub_v1
from slack.signature import SignatureVerifier

def send_gke_req(request):
    print(request)

    raw_request = request.get_data().decode()
    slack_request = request.form.to_dict(flat=True)

    publisher = pubsub_v1.PublisherClient()
    project_id = os.environ['PROJECT_ID']
    topic_id = os.environ['TOPIC_ID']
    message_json = json.dumps({
    'data': {
        'message': slack_request['text'],
        'response_url': slack_request['response_url']
    },
    })
    message_bytes = message_json.encode('utf-8')
    topic_path = publisher.topic_path(project_id, topic_id)
    
    print(f'slack_request:{slack_request}')
    # get the full request from Slack
    if verify_signature(request, raw_request):    
    ## respond to Slack with quick message
        publisher.publish(topic_path, message_bytes)
        return f'You have requested the following - {slack_request["text"]} - we have assigned a Worker and will let you know soon!'
    else:
        return '400'

def verify_signature(request, raw_request):
    print(request)
    print(raw_request)

    slack_signing_secret = os.environ['SLACK_SECRET'].encode('utf-8')
    request_body = raw_request
    timestamp = request.headers['X-Slack-Request-Timestamp']
    slack_signature = request.headers['X-Slack-Signature']
    sig_basestring = f'v0:{timestamp}:{request_body}'.encode('utf-8')    
    my_signature = f'v0={hmac.new(slack_signing_secret,sig_basestring,hashlib.sha256).hexdigest()}'
    
    print(f'{slack_signature} + {my_signature} + {sig_basestring}')
    print(f'request_body: {request_body}')
    
    if abs(time.time() - float(timestamp)) > 60 * 5:
    # The request timestamp is more than five minutes from local time.
    # It could be a replay attack, so let's ignore it.
        print('Timestamp was out of range - could be repeat attack!?')
        return False

    if hmac.compare_digest(my_signature, slack_signature):
    # hooray, the request came from Slack!
        return True
    else:
        return False