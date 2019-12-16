import boto3
from botocore.vendored import requests
from datetime import datetime
import shutil
import os
import random


def lambda_handler(event, context):
    try:
        url = event["url"]
        name = event["name"]
        bucket = os.environ['BUCKET']
        s3_path = f"s3://{bucket}/{name}"
        hash = random.getrandbits(128)
        save_id = "%032x" % hash
        filepath = "/tmp/"+ name

        # download image from url
        r = requests.get(url, stream=True)
        if r.status_code == 200:
            with open(filepath, 'wb') as f:
                r.raw.decode_content = True
                shutil.copyfileobj(r.raw, f)

        # upload image to s3
        s3 = boto3.client('s3')
        now = datetime.now() 
        date_time = now.strftime("%m/%d/%Y-%H:%M:%S")
        with open(filepath, "rb") as f:
            s3.upload_fileobj(f, bucket, name)
        
        # remove image
        os.remove(filepath)        
        
        # save info on database table
        dynamodb = boto3.client('dynamodb')
        dynamodb.put_item(TableName='image-api-table', Item={'SaveId':{'S': save_id},'Name':{'S': name}, 'Url':{'S': url}, 'S3Path':{'S': s3_path}, 'Date':{'S': date_time}})

        return {
            "result" : "Saved successfully",
            "name" : name,
            "storage" : s3_path,
            "date" : date_time
        }

    except BaseException as error:
        return {
            "result" : "Failed to save image",
            "error" : str(error)
        }
