import boto3

def lambda_handler():
    try:
        s3 = boto3.resource('s3')
        bucket = s3.Bucket('api-test-2019-saved-images')
        response = {"images":[]}

        for bucket_obj in bucket.objects.all():
            response["images"].append(bucket_obj.key)

        return response

    except BaseException as error:
        print("Failed to list images")
        return str(error)
