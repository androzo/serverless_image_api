import boto3

def list_image(event, context):
    try:
        s3 = boto3.resource('s3')
        client_s3 = boto3.client('s3')
        brand_upper = event["url"].upper()
        bucket = s3.Bucket("saved_images")
        keys = bucket.get_all_keys()

        for obj in bucket.objects.filter(Prefix='images/'):
            name = obj.key

        # list objects

        # parse to json

        # return parsed json
            
        return("Failure to list S3 images")

    except BaseException as error:
        print("Failure to retrieve  Image")
        return str(error)