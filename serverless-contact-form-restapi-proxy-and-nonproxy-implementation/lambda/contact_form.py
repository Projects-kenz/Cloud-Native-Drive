#---------------------------------------------------------------------------
# PROXY integration (REST API)----------------------------------------------
#---------------------------------------------------------------------------
import json
import boto3
import os
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS, GET',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
    }
    
    
    try:
        body = json.loads(event['body']) if event.get('body') else {}
        
        name = body.get('name', '').strip()
        email = body.get('email', '').strip()
        message = body.get('message', '').strip()
        
        if not name or not email or not message:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'All fields are required'})
            }
        
        submission_id = str(uuid.uuid4())
        timestamp = datetime.utcnow().isoformat()
        
        item = {
            'submissionId': submission_id,
            'name': name,
            'email': email,
            'message': message,
            'timestamp': timestamp,
        }
        
        table.put_item(Item=item)
        
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({
                'message': 'Form submitted successfully!',
                'submissionId': submission_id
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': 'Internal server error'})
        }
    



#---------------------------------------------------------------------------
    # NON proxy integration (REST API)--------------------------------------
#---------------------------------------------------------------------------

    
# import json
#import boto3
#import os
#import uuid
#from datetime import datetime

#dynamodb = boto3.resource('dynamodb')
#table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

#def lambda_handler(event, context):
    #try:
       
       # body = event.get('body', {})
        
      #  name = body.get('name', '').strip()
     #   email = body.get('email', '').strip()
    #    message = body.get('message', '').strip()

  #      print(f"DEBUG - Name: '{name}', Email: '{email}', Message: '{message}'")

        #if not name or not email or not message:
          #  print("DEBUG - Validation failed: empty fields")
         #   return {'error': 'All fields are required'}

        #submission_id = str(uuid.uuid4())
        #timestamp = datetime.utcnow().isoformat()

        #item = {
            #'submissionId': submission_id,
           # 'name': name,
           # 'email': email,
          #  'message': message,
         #   'timestamp': timestamp,
        #}

        #table.put_item(Item=item)
        #print("DEBUG - Successfully saved to DynamoDB")

        #return {
       #     'message': 'Form submitted successfully!',
      #      'submissionId': submission_id
     #   }

    #except Exception as e:
        #print(f"DEBUG - Error: {str(e)}")
        #return {'error': 'Internal server error'}

