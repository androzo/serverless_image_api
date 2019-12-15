import boto3

def lambda_handler(event, context):
    try:
        s3 = boto3.resource('s3')
        bucket = s3.Bucket('api-test-2019-saved-images')
        response = {"saved_images":[]}

        for bucket_obj in bucket.objects.all():
            response["saved_images"].append(bucket_obj.key)

        return response

    except BaseException as error:
        return {
            "result" : "Failed list images",
            "error" : str(error)
        }