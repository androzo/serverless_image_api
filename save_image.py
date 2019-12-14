import boto3
import requests
import shutil
import os

def lambda_handler(url, name):
    try:
        s3 = boto3.client('s3')

        # download image from url
        r = requests.get(url, stream=True)
        if r.status_code == 200:
            with open(name, 'wb') as f:
                r.raw.decode_content = True
                shutil.copyfileobj(r.raw, f)

        # upload image to s3
        with open(name, "rb") as f:
            s3.upload_fileobj(f, "api-test-2019-saved-images", name)
        
        # remove image
        os.remove(os.path.dirname(os.path.realpath(name)) + "\\" + name)

        return(f"Saved image [{name}] from [{url}] to S3")

    except BaseException as error:
        print("Failed to save image to S3")
        return str(error)
