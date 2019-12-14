import boto3
from botocore.vendored import requests
import shutil
import os

def lambda_handler(event, context):
    try:
        s3 = boto3.client('s3')
        url = event["url"]
        name = event["name"]
        filepath = "/tmp/"+ name

        # download image from url
        r = requests.get(url, stream=True)
        if r.status_code == 200:
            with open(filepath, 'wb') as f:
                r.raw.decode_content = True
                shutil.copyfileobj(r.raw, f)

        # upload image to s3
        with open(filepath, "rb") as f:
            s3.upload_fileobj(f, "api-test-2019-saved-images", name)
        
        # remove image
        os.remove(filepath)

        return(f"Saved image [{name}] from [{url}] to S3")

    except BaseException as error:
        print("Failed to save image to S3")
        return str(error)
