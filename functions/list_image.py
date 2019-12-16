import boto3
import os

def lambda_handler(event, context):
    try:        
        s3 = boto3.resource('s3')
        bucket = s3.Bucket(os.environ['BUCKET'])
        response = {"saved_images":[]}

        for bucket_obj in bucket.objects.all():
            response["saved_images"].append(bucket_obj.key)

        return response

    except BaseException as error:
        return {
            "result" : "Failed to list images",
            "error" : str(error)
        }